abstract class Enemy extends GameCharacter{
  EnemyState state;
  EnemyState pState;
  
  boolean isDead=false;
  
  Enemy(float x,float y){
    super();
    pos.set(x,y);
  }
  
  void updatePreState(){
    if(pState!=state){
      if(getNowState()!=null)getNowState().rewind();
    }
    pState=state;
  }
  
  void resetState(){
    state=EnemyState.Stop;
  }
  
  void setState(Object s){
    if(((EnemyState)s).isStrong(state))state=(EnemyState)s;
  }
  
  void updateState(){
    if(!ground){
      setState(EnemyState.Jump);
    }
    Process_Run();
  }
  
  void Process_Run(){
    //if(nowPressedKey.contains('d')){
    //  accel.add(1,0);
    //  setDirection(DirectionData.Right);
    //  setState(EnemyState.Run);
    //}
    //if(nowPressedKey.contains('a')){
    //  accel.add(-1,0);
    //  setDirection(DirectionData.Left);
    //  setState(EnemyState.Run);
    //}
  }
  
  String getStateText(){
    return state.toString().toLowerCase()+"_"+getDirectionText();
  }
  
  abstract void Collision(Player p);
}

class TestEnemy extends Enemy{
  
  TestEnemy(float x,float y){
    super(x,y);
    setRigidBody(new RigidBody(
        Collider.AABB,
        ()->{
          return pos;
        },()->{
          return new PVector(20,20);
        },()->{
          return vel;
        }
      )
    );
  }
  
  @Override
  public void display(){
    noStroke();
    fill(isDead?100:255,0,0);
    rectMode(CENTER);
    rect(pos.x,pos.y,20,20);
  }
  
  void Collision(Player p){
    CollisionData data=getRigidBody().Collision(p.getRigidBody());
    if(data.isHit()&&p.getStateText().contains("attack")){
      isDead=true;
    }
  }
}
  
enum EnemyState{
  Stop(0),
  Run(1),
  Jump(2);
  
  private final int strength;
  
  private EnemyState(int strength){
    this.strength=strength;
  }
  
  public int getStrength(){
    return strength;
  }
  
  public boolean isStrong(EnemyState p){
    return strength>=p.getStrength();
  }
}
