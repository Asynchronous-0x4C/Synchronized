package Synchronized.GameObject.Block;

import org.jbox2d.common.Vec2;

import Synchronized.GameObject.GameObject;
import fisica.FBox;
import fisica.FWorld;

public abstract class Block extends GameObject{
  protected FWorld world;
  protected FBox body;

  public Block(float x,float y,FWorld world){
    position=new Vec2(x, y);
    velocity=new Vec2(0f,0f);
    this.world=world;
  }

  public abstract void initBody();
}
