abstract class Entity{
  private RigidBody r_body;
  PVector prePos;
  PVector pos;
  PVector preVel;
  PVector vel;
  PVector accel;
  
  Entity(){
    prePos=new PVector();
    pos=new PVector();
    preVel=new PVector();
    vel=new PVector();
    accel=new PVector();
  }
  
  abstract void display();
  
  abstract void update();
  
  PVector getPos(){
    return pos;
  }
  
  PVector getVel(){
    return vel;
  }
  
  void setRigidBody(RigidBody a){
    r_body=a;
  }
  
  RigidBody getRigidBody(){
    return r_body;
  }
  
  void translate(float x,float y){
    pos.add(x,y);
  }
}

abstract class GameCharacter extends Entity{
  ArrayList<Runnable>Queue;
  HashMap<String,State>states;
  PImage image;
  
  private DirectionData Direction=DirectionData.Right;
  
  boolean ground=false;
  
  GameCharacter(){
    super();
    Queue=new ArrayList<Runnable>();
    states=new HashMap<>();
  }
  
  void display(){
    imageMode(CENTER);
    image(states.get(getStateText()).getImage(),pos.x,pos.y,64,64);
  }
  
  void update(){
    vel.set(PVector.sub(pos,prePos));
    ground=preVel.y>vel.y;
    vel.x*=0;
    vel.y*=1;
    prePos.set(pos);
    accel.set(0,0);
    accel.add(0,Gravity);
    stateProcess();
    vel.add(accel);
    preVel.set(vel);
    pos.add(vel);
  }
  
  void stateProcess(){
    resetState();
    Queue.forEach(r->r.run());
    Queue.clear();
    updateState();
    if(getNowState()!=null)getNowState().update();
    updatePreState();
  }
  
  abstract void resetState();
  
  abstract void setState(Object s);
  
  abstract void updateState();
  
  abstract void updatePreState();
  
  String getDirectionText(){
    return Direction.toString().toLowerCase();
  }
  
  DirectionData getDirection(){
    return Direction;
  }
  
  void setDirection(DirectionData dir){
    Direction=dir;
  }
  
  abstract String getStateText();
  
  State getNowState(){
    return states.get(getStateText());
  }
  
  void translate(float x,float y){
    pos.add(x,y);
  }
}
