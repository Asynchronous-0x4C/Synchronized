abstract class Block{
  FBox box;
  PImage image;
  PVector pos;
  RigidBody r_body;
  
  Block(float x,float y){
    pos=new PVector(x,y);
    r_body=new RigidBody(Collider.AABB,()->{return new PVector(x,y);},()->{return new PVector(40,40);},()->{return new PVector(0,0);});
  }
  
  void update(){
    
  }
  
  void display(){
    rectMode(CENTER);
    noStroke();
    fill(70);
    rect(pos.x,pos.y,40,40);
  }
  
  public void Collision(GameCharacter c){
    CollisionData data=r_body.Collision(c.getRigidBody());
    if(data.isHit()){
      if(c.ground){
        c.translate(0,(r_body.getPos().y-c.getRigidBody().getPos().y)-(r_body.getDist().y+c.getRigidBody().getDist().y)*0.5);
        return;
      }
      switch(data.getDirection().intValue()){
        case UP:c.translate(0,(r_body.getPos().y-c.getRigidBody().getPos().y)-(r_body.getDist().y+c.getRigidBody().getDist().y)*0.5);break;
        case DOWN:c.translate(0,-(c.getRigidBody().getPos().y-r_body.getPos().y)+(c.getRigidBody().getDist().y+r_body.getDist().y)*0.5);break;
        case RIGHT:c.translate((c.getRigidBody().getDist().x+r_body.getDist().x)*0.5-(c.getRigidBody().getPos().x-r_body.getPos().x),0);break;
        case LEFT:c.translate(-(r_body.getDist().x+c.getRigidBody().getDist().x)*0.5+(r_body.getPos().x-c.getRigidBody().getPos().x),0);break;
      }
    }
  }
}

class DefaultBlock extends Block{
  
  DefaultBlock(float x,float y){
    super(x,y);
  }
}

class ThroughBlock extends Block{
  DirectionData dir;
  
  ThroughBlock(float x,float y){
    this(x,y,DirectionData.Up);
  }
  
  ThroughBlock(float x,float y,DirectionData dir){
    super(x,y);
    this.dir=dir;
  }
  
  void display(){
    rectMode(CENTER);
    noStroke();
    fill(0,255,128);
    switch(dir.intValue()){
      case UP:rect(pos.x,pos.y-17.5,40,5);break;
      case DOWN:rect(pos.x,pos.y+17.5,40,5);break;
      case RIGHT:rect(pos.x+17.5,pos.y,5,40);break;
      case LEFT:rect(pos.x-17.5,pos.x,5,40);break;
    }
  }
  
  @Override
  public void Collision(GameCharacter c){
    CollisionData data=r_body.Collision(c.getRigidBody());
    if(data.isHit()&&dir==data.getDirection()){
      switch(data.getDirection().intValue()){
        case UP:c.translate(0,(r_body.getPos().y-c.getRigidBody().getPos().y)-(r_body.getDist().y+c.getRigidBody().getDist().y)*0.5);break;
        case DOWN:c.translate(0,-(c.getRigidBody().getPos().y-r_body.getPos().y)+(c.getRigidBody().getDist().y+r_body.getDist().y)*0.5);break;
        case RIGHT:c.translate((c.getRigidBody().getDist().x+r_body.getDist().x)*0.5-(c.getRigidBody().getPos().x-r_body.getPos().x),0);break;
        case LEFT:c.translate(-(r_body.getDist().x+c.getRigidBody().getDist().x)*0.5+(r_body.getPos().x-c.getRigidBody().getPos().x),0);break;
      }
    }
  }
}

class LiftBlock extends Block{
  PVector start;
  PVector end;
  
  PVector vel;
  float speed;
  float time;
  float stop=0;
  
  float Friction=1;
  
  Animator anim;
  
  LiftBlock(float x,float y,float dx,float dy,float speed){
    super(x,y);
    vel=new PVector();
    start=new PVector(x,y);
    end=new PVector(x+dx,y+dy);
    this.speed=speed;
    time=PVector.sub(start,end).mag()/speed;
    r_body=new RigidBody(Collider.AABB,()->{return pos;},()->{return new PVector(40,40);},()->{return vel;});
    anim=new Animator((cum,millis)->{
      if(cum>time*60+1000){
        anim.setMagnification(-1);
      }
      if(cum<-1000){
        anim.setMagnification(1);
      }
      PVector next=PVector.lerp(start,end,max(0,min(1,cum/(time*60))));
      vel=PVector.sub(next,pos);
      pos=next;
    });
  }
  
  @Override
  public void update(){
    anim.animate();
  }
  
  @Override
  public void Collision(GameCharacter c){
    CollisionData data=r_body.Collision(c.getRigidBody());
    if(data.isHit()){
      switch(data.getDirection().intValue()){
        case UP:c.translate(vel.x*Friction,(r_body.getPos().y-c.getRigidBody().getPos().y)-(r_body.getDist().y+c.getRigidBody().getDist().y)*0.5);break;
        case DOWN:c.translate(0,-(c.getRigidBody().getPos().y-r_body.getPos().y)+(c.getRigidBody().getDist().y+r_body.getDist().y)*0.5);break;
        case RIGHT:c.translate((c.getRigidBody().getDist().x+r_body.getDist().x)*0.5-(c.getRigidBody().getPos().x-r_body.getPos().x),0);break;
        case LEFT:c.translate(-(r_body.getDist().x+c.getRigidBody().getDist().x)*0.5+(r_body.getPos().x-c.getRigidBody().getPos().x),0);break;
      }
    }
  }
}
