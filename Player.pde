class Player extends GameCharacter{
  private PlayerState state=PlayerState.Stop;
  private PlayerState pState=state;
  boolean fullSpeed=false;
  int nowAttack=0;
  int attack=0;
  
  Player(){
    super();
    setRigidBody(new RigidBody(Collider.AABB,
      ()->{
        PVector ret=new PVector();
        switch(getDirection().intValue()){
          case RIGHT:ret.set(pos.x-1,pos.y+5);break;
          case LEFT:ret.set(pos.x+1,pos.y+5);break;
        }
        return ret;
      },()->{
        return new PVector(26,54);
      },()->{
        return vel;
      })
    );
    accel=new PVector();
    keyPressedProcess.add(e->{
      switch((char)Character.toLowerCase(e.getKey())){
        case ' ':Queue.add(()->{if(nowAttack==0)Process_Jump();});break;
        case 'x':Queue.add(()->{if(getDirection()==DirectionData.Right){accel.add(160,0);}else{accel.add(-160,0);}});break;
        case 'z':Queue.add(()->{++attack;attack=min(3,attack);if(nowAttack==0)nowAttack++;});break;
      }
      switch(e.getKeyCode()){
        case SHIFT:Queue.add(()->{if(ground)fullSpeed=true;});break;
      }
    });
    keyReleasedProcess.add(e->{
      switch(e.getKeyCode()){
        case SHIFT:Queue.add(()->{fullSpeed=false;});break;
      }
    });
    states.put("stop_left",new State(180,"player_stop_left",3,".png"));
    states.put("stop_right",new State(180,"player_stop_right",3,".png"));
    states.put("run_left",new State(180,"player_run_left",4,".png"));
    states.put("run_right",new State(180,"player_run_right",4,".png"));
    states.put("fullspeed_left",new State(90,"player_run_left",4,".png"));
    states.put("fullspeed_right",new State(90,"player_run_right",4,".png"));
    states.put("jump_left",new State(1000,"player_jump_left",1,".png"));
    states.put("jump_right",new State(1000,"player_jump_right",1,".png"));
    states.put("attack_0_left",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_1);nowAttack++;}else{attack=nowAttack=0;}},"player_attack_0_left",3,".png"));
    states.put("attack_0_right",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_1);nowAttack++;}else{attack=nowAttack=0;}},"player_attack_0_right",3,".png"));
    states.put("attack_1_left",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_2);nowAttack++;}else{attack=nowAttack=0;}},"player_attack_1_left",3,".png"));
    states.put("attack_1_right",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_2);nowAttack++;}else{attack=nowAttack=0;}},"player_attack_1_right",3,".png"));
    states.put("attack_2_left",new State(100,1,()->{attack=nowAttack=0;},"player_attack_2_left",3,".png"));
    states.put("attack_2_right",new State(100,1,()->{attack=nowAttack=0;},"player_attack_2_right",3,".png"));
  }
  
   public void updateState(){
    switch(nowAttack){
      case 1:setState(PlayerState.Attack_0);break;
      case 2:setState(PlayerState.Attack_1);break;
      case 3:setState(PlayerState.Attack_2);break;
      default:
        if(!ground){
          setState(PlayerState.Jump);
        }
        Process_Run();
        break;
    }
  }
  
   public void updatePreState(){
    if(pState!=state){
      states.get(getStateText()).rewind();
    }
    pState=state;
  }
  
   public void Process_Run(){
    if(nowPressedKey.contains('d')){
      accel.add(3,0);
      setDirection(DirectionData.Right);
      setState(PlayerState.Run);
      if(fullSpeed){
        accel.add(3,0);
        setState(PlayerState.FullSpeed);
      }
    }
    if(nowPressedKey.contains('a')){
      accel.add(-3,0);
      setDirection(DirectionData.Left);
      setState(PlayerState.Run);
      if(fullSpeed){
        accel.add(-3,0);
        setState(PlayerState.FullSpeed);
      }
    }
  }
  
   public void Process_Jump(){
    if(ground){
      accel.add(0,-18);
    }
  }
  
   public void resetState(){
    state=PlayerState.Stop;
  }
  
   public void setState(Object s){
    if(((PlayerState)s).isStrong(state))state=(PlayerState)s;
  }
  
   public String getStateText(){
    return state.toString().toLowerCase()+"_"+getDirectionText();
  }
  
   public void respown(){
    prePos.set(pos.set(spownPoint));
    attack=nowAttack=0;
  }
}

class Camera{
  private PVector Center;
  private PVector vel;
  private Entity Target;
  
  Camera(Entity target){
    Target=target;
    Center=new PVector();
    vel=new PVector();
  }
  
   public void setTarget(Entity target){
    Target=target;
  }
  
   public void display(){
    vel.add(PVector.sub(Target.getVel(),vel).mult(0.5f)).mult(1-min(1,vel.mag()*0.005f));
    Center.set(Target.getPos()).sub(vel);
    resetMatrix();
    translate(width*0.5f-Center.x,height*0.5f-Center.y);
  }
}
  
enum PlayerState{
  Stop(0),
  Run(1),
  FullSpeed(1),
  Jump(2),
  Attack_0(3),
  Attack_1(3),
  Attack_2(3);
  
  private final int strength;
  
  private PlayerState(int strength){
    this.strength=strength;
  }
  
  public int getStrength(){
    return strength;
  }
  
  public boolean isStrong(PlayerState p){
    return strength>=p.getStrength();
  }
}
