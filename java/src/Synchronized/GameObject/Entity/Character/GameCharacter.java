package Synchronized.GameObject.Entity.Character;

import java.util.HashMap;

import Synchronized.GameObject.Entity.Entity;
import fisica.FWorld;
import processing.core.PImage;

public abstract class GameCharacter extends Entity {
  protected HashMap<String,State>stateMap;
  protected FWorld world;
  protected PImage image;
  protected Direction direction=Direction.Right;

  protected boolean ground=false;

  public GameCharacter(float x,float y,float dx,float dy,FWorld world){
    super(x,y,dx,dy);
    stateMap=new HashMap<>();
    this.world=world;
    initBody(x, y, dx, dy);
  }

  public abstract void initBody(float x,float y,float dx,float dy);
  
  protected final void stateProcess(){
    resetState();
    updateState();
    if(getNowState()!=null)getNowState().update();
    updatePreState();
  }

  public void setImage(PImage i){
    image=i;
  }

  public PImage getImage(){
    return image;
  }
  
  protected abstract void resetState();
  
  protected abstract void updateState();
  
  protected abstract void updatePreState();
  
  protected abstract void setState(StateBase s);
  
  public String getDirectionText(){
    return direction.toString().toLowerCase();
  }
  
  public Direction getDirection(){
    return direction;
  }
  
  protected void setDirection(Direction dir){
    direction=dir;
  }
  
  public abstract String getStateText();
  
  public State getNowState(){
    return stateMap.get(getStateText());
  }
}
