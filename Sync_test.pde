import fisica.*;

import java.lang.reflect.*;

import java.util.function.*;

FWorld world;

Player player;

Camera camera;

PVector spownPoint;

ArrayList<Block>Blocks=new ArrayList<>();
ArrayList<Enemy>Enemies=new ArrayList<>();

ArrayList<Character>nowPressedKey=new ArrayList<>();
ArrayList<Integer>nowPressedKeyCode=new ArrayList<>();

ArrayList<Consumer<KeyEvent>>keyPressedProcess=new ArrayList<>();
ArrayList<Consumer<KeyEvent>>keyReleasedProcess=new ArrayList<>();

float timeMagnification;
float frameMillis;
long pTime;

int backgroundColor;

int global_layer=0;

float Gravity=1;

void setup(){
  size(1280,720,P2D);
  Fisica.init(this);
  world=new FWorld();
  player=new Player();
  camera=new Camera(player);
  spownPoint=new PVector(0,0);
  player.respown();
  for(int i=0;i<200;i++){
    for(int j=0;j<200;j++){
      Blocks.add(new DefaultBlock(20+i*40+(ceil(i/10)-1)*80+j*160,140+j*120));
    }
  }
  Blocks.add(new LiftBlock(-100,140,-360,0,6));
  Enemies.add(new TestEnemy(0,0));
  try{
    Field f=PGraphicsOpenGL.class.getDeclaredField("textureSampling");
    f.setAccessible(true);
    f.set(g,2);
  }catch(Exception e){
    e.printStackTrace();
  }
  backgroundColor=color(30,158,255);
  keyPressedProcess.add(e->{
    nowPressedKey.add((Character)Character.toLowerCase(e.getKey()));
    nowPressedKeyCode.add(e.getKeyCode());
  });
  keyReleasedProcess.add(e->{
    nowPressedKey.remove((Character)Character.toLowerCase((Character)e.getKey()));
    nowPressedKeyCode.remove((Integer)e.getKeyCode());
  });
}

void draw(){
  setFPSData();
  background(backgroundColor);
  player.update();
  Enemies.forEach(e->e.update());
  Blocks.forEach(b->b.update());
  Blocks.forEach(b->{b.Collision(player);Enemies.forEach(e->b.Collision(e));});
  Enemies.forEach(e->e.Collision(player));
  if(player.getPos().y>32768)player.respown();
  camera.display();
  player.display();
  Enemies.forEach(e->e.display());
  Blocks.forEach(b->b.display());
}

void setFPSData(){
  frameMillis=frameCount==1?16:(System.nanoTime()-pTime)/1E6;
  timeMagnification=16f/frameMillis;
  pTime=System.nanoTime();
  
}

boolean sqDist(PVector a,PVector b,float d){
  return (a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y)<d*d;
}

float cross(PVector x,PVector y){
  return x.x*y.y-x.y*y.x;
}

void keyPressed(KeyEvent e){
  keyPressedProcess.forEach(c->c.accept(e));
}

void keyReleased(KeyEvent e){
  keyReleasedProcess.forEach(c->c.accept(e));
}

class KeyProcess{
  private Consumer<KeyEvent>process;
  private String type;
  private int layer;
  
  KeyProcess(int layer,String type,Consumer<KeyEvent>src){
    process=src;
    this.layer=layer;
    this.type=type;
  }
  
  void invoke(KeyEvent e){
    boolean invoke=false;
    switch(type){
      case "equal":invoke=global_layer==layer;break;
      case "notequal":invoke=global_layer!=layer;break;
      case "lessthan":invoke=global_layer>layer;break;
      case "lessequal":invoke=global_layer>=layer;break;
      case "greaterthan":invoke=global_layer<layer;break;
      case "greaterequal":invoke=global_layer<=layer;break;
    }
    if(invoke)process.accept(e);
  }
}

class Animator{
  private BiConsumer<Float,Float>process;
  private boolean loop=true;
  private float cumlativeTime=0;
  private float mag=1;
  
  public Animator(BiConsumer<Float,Float>arg){
    process=arg;
  }
  
  public void animate(){
    if(!loop)return;
    process.accept(cumlativeTime,frameMillis);
    cumlativeTime+=frameMillis*mag;
  }
  
  public void setMagnification(float mag){
    this.mag=mag;
  }
  
  public void resetCumlativeTime(){
    cumlativeTime=0;
  }
  
  public void stop(){
    loop=false;
  }
  
  public boolean isLoop(){
    return loop;
  }
  
  public void start(){
    loop=true;
  }
}

class State{
  private ArrayList<PImage>images;
  private PImage nowImage;
  private Animator anim;
  private Runnable end=()->{};
  private boolean run=true;
  private int maxLoop=-1;
  private int loopNum;
  private int num;
  
  public State(float duration,String names,int frame,String ext){
    images=new ArrayList<>();
    for(int i=0;i<frame;i++){
      images.add(loadImage(names+(frame==1?"":"_"+i)+ext));
    }
    nowImage=images.get(0);
    num=0;
    anim=new Animator((cum,millis)->{
      run=true;
      if(cum>duration*(1+num)){
        num++;
        if(num>=images.size()){
          anim.resetCumlativeTime();
          loopNum++;
          if(maxLoop!=-1&&loopNum>=maxLoop){
            run=false;
            end.run();
          }
          if(run){
            num=0;
          }
        }
        if(run)this.setImage(images.get(num));
      }
    });
  }
  
  public State(float duration,int maxLoop,Runnable end,String names,int num,String ext){
    this(duration,names,num,ext);
    this.end=end;
    this.maxLoop=maxLoop;
  }
  
  public void update(){
    
    anim.animate();
  }
  
  private void setImage(PImage i){
    nowImage=i;
  }
  
  public PImage getImage(){
    return nowImage;
  }
  
  public void rewind(){
    loopNum=num=0;
    anim.resetCumlativeTime();
    this.setImage(images.get(0));
    anim.start();
  }
}

class RigidBody{
  private ArrayList<RigidBody>Child;
  private Supplier<PVector>posSupplier;
  private Supplier<PVector>distSupplier;
  private Supplier<PVector>velSupplier;
  private Collider shape;
  private AABB sweep;
  private AABB aabb;
  
  
  
  RigidBody(Collider c,Supplier<PVector> ps,Supplier<PVector> ds,Supplier<PVector> vs){
    shape=c;
    posSupplier=ps;
    distSupplier=ds;
    velSupplier=vs;
    aabb=new AABB(ps,ds,vs);
  }
  
  RigidBody(ArrayList<RigidBody>child){
    Child=child;
  }
  
  PVector getPos(){
    return posSupplier.get();
  }
  
  PVector getDist(){
    return distSupplier.get();
  }
  
  PVector getVel(){
    return velSupplier.get();
  }
  
  ArrayList<RigidBody> getChild(){
    return Child;
  }
  
  Collider getShape(){
    return shape;
  }
  
  AABB getAABB(){
    if(Child!=null){
      float min_x=Child.get(0).getAABB().getPos().x-Child.get(0).getAABB().getDist().x*0.5;
      float min_y=Child.get(0).getAABB().getPos().y-Child.get(0).getAABB().getDist().y*0.5;
      float max_x=Child.get(0).getAABB().getPos().x+Child.get(0).getAABB().getDist().x*0.5;
      float max_y=Child.get(0).getAABB().getPos().y+Child.get(0).getAABB().getDist().y*0.5;
      float[]i={0,min_x,min_y,max_x,max_y};
      Child.forEach(c->{
        if(i[0]==0){
          i[0]++;
          return;
        }
        i[1]=min(i[1],c.getAABB().getPos().x-c.getAABB().getDist().x*0.5);
        i[2]=min(i[2],c.getAABB().getPos().y-c.getAABB().getDist().y*0.5);
        i[3]=min(i[3],c.getAABB().getPos().x+c.getAABB().getDist().x*0.5);
        i[4]=min(i[4],c.getAABB().getPos().y+c.getAABB().getDist().y*0.5);
      });
      aabb=new AABB((i[1]+i[3])*0.5,(i[2]+i[4])*0.5,(i[3]-i[1]),(i[4]-i[2]),getVel());
    }
    return aabb;
  }
  
  AABB getSweepVolume(){
    if(Child==null){
      sweep=aabb.getSweepVolume();
    }else{
      float min_x=Child.get(0).getSweepVolume().getPos().x-Child.get(0).getSweepVolume().getDist().x*0.5;
      float min_y=Child.get(0).getSweepVolume().getPos().y-Child.get(0).getSweepVolume().getDist().y*0.5;
      float max_x=Child.get(0).getSweepVolume().getPos().x+Child.get(0).getSweepVolume().getDist().x*0.5;
      float max_y=Child.get(0).getSweepVolume().getPos().y+Child.get(0).getSweepVolume().getDist().y*0.5;
      float[]i={0,min_x,min_y,max_x,max_y};
      Child.forEach(c->{
        if(i[0]==0){
          i[0]++;
          return;
        }
        i[1]=min(i[1],c.getSweepVolume().getPos().x-c.getSweepVolume().getDist().x*0.5);
        i[2]=min(i[2],c.getSweepVolume().getPos().y-c.getSweepVolume().getDist().y*0.5);
        i[3]=min(i[3],c.getSweepVolume().getPos().x+c.getSweepVolume().getDist().x*0.5);
        i[4]=min(i[4],c.getSweepVolume().getPos().y+c.getSweepVolume().getDist().y*0.5);
      });
    }
    return sweep;
  }
  
  CollisionData Collision(RigidBody b){
    CollisionData data=getAABB().Collision(b.getAABB());
    if(data.isHit()){
      if(!(getShape()==Collider.AABB&&b.getShape()==Collider.AABB)){
        if(getShape()==Collider.Circle&&b.getShape()==Collider.Circle){
          data.setHit(sqDist(getPos(),b.getPos(),(getDist().x+b.getDist().x)*0.5));
        }else{
          if(getShape()==Collider.AABB){
            data.setHit(Circle_AABB(b.getAABB(),getAABB(),b.getDist().x*0.5));
          }else{
            data.setHit(Circle_AABB(getAABB(),b.getAABB(),getDist().x*0.5));
          }
        }
      }
    }
    return data;
  }
  
  boolean Circle_AABB(AABB c,AABB a,float d){
    PVector point=c.getPos();
    float sqLen=0;
    float[]p=point.array();
    float[]min=PVector.sub(a.getPos(),PVector.mult(a.getDist(),0.5)).array();
    float[]max=PVector.add(a.getPos(),PVector.mult(a.getDist(),0.5)).array();
    for(int i=0;i<2;i++){
      if(p[i]<min[i])
        sqLen+=(p[i]-min[i])*(p[i]-min[i]);
      if(p[i]>max[i])
        sqLen+=(p[i]-max[i])*(p[i]-max[i]);
    }
    return sqLen<d*d;
  }
  
  //CollisionData StrictCollision(Collider c){
    
  //}
}

enum Collider{
  Circle,
  AABB
}

class AABB{
  private PVector pos;
  private PVector dist;
  private PVector vel;
  private Supplier<PVector>posSupplier;
  private Supplier<PVector>distSupplier;
  private Supplier<PVector>velSupplier;
  
  AABB(float x,float y,float dx,float dy,PVector vel){
    pos=new PVector(x,y);
    dist=new PVector(dx,dy);
    this.vel=vel;
  }
  
  AABB(Supplier<PVector>ps,Supplier<PVector>ds,Supplier<PVector>vs){
    posSupplier=ps;
    distSupplier=ds;
    velSupplier=vs;
  }
  
  void display(){
    noFill();
    stroke(255);
    rect(getPos().x,getPos().y,getDist().x,getDist().y);
  }
  
  void setPos(float x,float y){
    pos.set(x,y);
  }
  
  PVector getPos(){
    return posSupplier==null?pos:posSupplier.get();
  }
  
  void setDist(float x,float y){
    dist.set(x,y);
  }
  
  PVector getDist(){
    return distSupplier==null?dist:distSupplier.get();
  }
  
  void setVel(float x,float y){
    vel.set(x,y);
  }
  
  PVector getVel(){
    return velSupplier==null?vel:velSupplier.get();
  }
  
  AABB getSweepVolume(){
    return new AABB(getPos().x-getVel().x*0.5,getPos().y-getVel().y*0.5,getDist().x+abs(getVel().x),getDist().y+abs(getVel().y),getVel());
  }
  
  CollisionData Collision(AABB b){
    if(abs(getPos().x-b.getPos().x)<(getDist().x+b.getDist().x)*0.5&&
       abs(getPos().y-b.getPos().y)<(getDist().y+b.getDist().y)*0.5){
      PVector relativeSpeed=PVector.add(b.getVel(),PVector.mult(getVel(),-1));
      PVector b_relativePosition=PVector.sub(b.getPos(),relativeSpeed);
      DirectionData data=DirectionData.Right;
      if(b_relativePosition.x<getPos().x){
        //Left
        if(b_relativePosition.y<getPos().y){//Up
          PVector near=PVector.add(getPos(),new PVector(getDist().x*-0.5,getDist().y*-0.5));
          if(cross(PVector.sub(getPos(),b_relativePosition),PVector.sub(near,b_relativePosition))<=0){
            data=DirectionData.Left;
          }else{
            data=DirectionData.Up;
          }
        }else{//Down
          PVector near=PVector.add(getPos(),new PVector(getDist().x*-0.5,getDist().y*0.5));
          if(cross(PVector.sub(getPos(),b_relativePosition),PVector.sub(near,b_relativePosition))<=0){
            data=DirectionData.Down;
          }else{
            data=DirectionData.Left;
          }
        }
      }else{
        //Right
        if(b_relativePosition.y<getPos().y){//Up
          PVector near=PVector.add(getPos(),new PVector(getDist().x*0.5,getDist().y*-0.5));
          if(cross(PVector.sub(getPos(),b_relativePosition),PVector.sub(near,b_relativePosition))<=0){
            data=DirectionData.Up;
          }else{
            data=DirectionData.Right;
          }
        }else{//Down
          PVector near=PVector.add(getPos(),new PVector(getDist().x*0.5,getDist().y*0.5));
          if(cross(PVector.sub(getPos(),b_relativePosition),PVector.sub(near,b_relativePosition))<=0){
            data=DirectionData.Right;
          }else{
            data=DirectionData.Down;
          }
        }
      }
      return new CollisionData(true,data,this,b);
    }else{
      return new CollisionData(false,null,this,b);
    }
  }
}

class CollisionData{
  private boolean isHit=false;
  private DirectionData direction;
  private AABB[]aabb;
  
  CollisionData(boolean isHit,DirectionData dir,AABB... aabb){
    this.isHit=isHit;
    direction=dir;
    this.aabb=aabb;
  }
  
  boolean isHit(){
    return isHit;
  }
  
  void setHit(boolean b){
    isHit=b;
  }
  
  DirectionData getDirection(){
    return direction;
  }
  
  AABB[] getAABBArray(){
    return aabb;
  }
}

enum DirectionData{
  Right(RIGHT),
  Left(LEFT),
  Up(UP),
  Down(DOWN);
  
  private int num;
  
  DirectionData(int i){
    num=i;
  }
  
  int intValue(){
    return num;
  }
}
