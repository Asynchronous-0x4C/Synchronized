package Synchronized.GameObject.Entity.Character;

import org.jbox2d.common.Vec2;

import com.jogamp.newt.event.KeyEvent;

import Synchronized.Synchronized;
import fisica.FBox;
import fisica.FWorld;
import processing.core.PApplet;

public class PlayerCharacter extends GameCharacter {
  protected FBox body;
  private PlayerState state=PlayerState.Stop;
  private PlayerState pState=state;
  private float speed=175f;
  private int nowAttack=0;
  private int attack=0;
  
  public PlayerCharacter(float x,float y,FWorld world){
    super(x, y,26f, 54f, world);
    initState();
  }

  @Override
  public void initBody(float x,float y,float dx,float dy){
    body=new FBox(dx, dy);
    body.setPosition(x, y);
    body.setStatic(false);
    body.setRotatable(false);
    body.setRestitution(0f);
    body.setFriction(0.8f);
    body.setDensity(0.5f);
    world.addBody(body);
    position=body.getBox2dBody().getPosition();
  }

  private void initState(){
    stateMap.put("stop_left",new State(180,"images\\Player\\","player_stop_left",3,".png"));
    stateMap.put("stop_right",new State(180,"images\\Player\\","player_stop_right",3,".png"));
    stateMap.put("run_left",new State(180,"images\\Player\\","player_run_left",4,".png"));
    stateMap.put("run_right",new State(180,"images\\Player\\","player_run_right",4,".png"));
    stateMap.put("fullspeed_left",new State(90,"images\\Player\\","player_run_left",4,".png"));
    stateMap.put("fullspeed_right",new State(90,"images\\Player\\","player_run_right",4,".png"));
    stateMap.put("jump_left",new State(1000,"images\\Player\\","player_jump_left",1,".png"));
    stateMap.put("jump_right",new State(1000,"images\\Player\\","player_jump_right",1,".png"));
    stateMap.put("attack_0_left",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_1);nowAttack++;}else{attack=nowAttack=0;}},"images\\Player\\","player_attack_0_left",3,".png"));
    stateMap.put("attack_0_right",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_1);nowAttack++;}else{attack=nowAttack=0;}},"images\\Player\\","player_attack_0_right",3,".png"));
    stateMap.put("attack_1_left",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_2);nowAttack++;}else{attack=nowAttack=0;}},"images\\Player\\","player_attack_1_left",3,".png"));
    stateMap.put("attack_1_right",new State(70,1,()->{if(attack>nowAttack){setState(PlayerState.Attack_2);nowAttack++;}else{attack=nowAttack=0;}},"images\\Player\\","player_attack_1_right",3,".png"));
    stateMap.put("attack_2_left",new State(100,1,()->{attack=nowAttack=0;},"images\\Player\\","player_attack_2_left",3,".png"));
    stateMap.put("attack_2_right",new State(100,1,()->{attack=nowAttack=0;},"images\\Player\\","player_attack_2_right",3,".png"));
  }
  
  public void updateState(){
    Process_Attack();
    switch(nowAttack){
      case 1:setState(PlayerState.Attack_0);break;
      case 2:setState(PlayerState.Attack_1);break;
      case 3:setState(PlayerState.Attack_2);break;
      default:
        if(!ground){
          setState(PlayerState.Jump);
        }
        Process_Run();
        Process_Jump();
        break;
    }
  }
 
  public void updatePreState(){
    if(pState!=state){
      stateMap.get(getStateText()).rewind();
    }
    pState=state;
  }

  @Override
  protected void display(PApplet a){
    updatePosition();
    a.imageMode(PApplet.CENTER);
    a.image(stateMap.get(getStateText()).getImage(),body.getX(),body.getY()-5f,64f,64f);
  }

  @Override
  protected void update(){
    ground=PApplet.abs(body.getVelocityY())<7.105387E-13;
    stateProcess();
  }

  @Override
  public Vec2 updatePosition(){
    position.set(body.getX(),body.getY());
    return position;
  }

  protected void Process_Run(){
    if(Synchronized.input.getKey(KeyEvent.VK_D)){
      body.addImpulse((speed-body.getVelocityX())*0.95f, 0f);
      setDirection(Direction.Right);
      setState(PlayerState.Run);
      body.setFriction(0.8f);
      if(Synchronized.input.getKey(KeyEvent.VK_PAGE_UP)){
        body.addImpulse((speed*2f-body.getVelocityX())*0.95f, 0f);
        setState(PlayerState.FullSpeed);
        body.setFriction(0.175f);
      }
    }
    if(Synchronized.input.getKey(KeyEvent.VK_A)){
      body.addImpulse((-speed-body.getVelocityX())*0.95f, 0f);
      setDirection(Direction.Left);
      setState(PlayerState.Run);
      body.setFriction(0.8f);
      if(Synchronized.input.getKey(KeyEvent.VK_PAGE_UP)){
        body.addImpulse((-speed*2f-body.getVelocityX())*0.95f, 0f);
        setState(PlayerState.FullSpeed);
        body.setFriction(0.175f);
      }
    }
  }
  
  public void Process_Jump(){
    if(ground&&Synchronized.input.getKeyDown(KeyEvent.VK_SPACE)){
      body.addImpulse(0f, -1500f);
    }
  }

  public void Process_Attack(){
    if(Synchronized.input.getKeyDown(KeyEvent.VK_Z)){
      ++attack;
      attack=PApplet.min(3,attack);
      if(nowAttack==0)nowAttack++;
    }
  }
  
  public void resetState(){
     state=PlayerState.Stop;
  }
   
  public void setState(StateBase s){
     if(s.isStrong(state))state=(PlayerState)s;
  }
  
  public String getStateText(){
   return state.toString().toLowerCase()+"_"+getDirectionText();
 }
  
  private enum PlayerState implements StateBase{
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
    
    public boolean isStrong(StateBase p){
      return strength>=p.getStrength();
    }

    public StateBase getStateBase(){
      return this;
    }
  }
}
