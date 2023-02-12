package Synchronized.GameObject.Entity;

import org.jbox2d.common.Vec2;

import Synchronized.GameObject.GameObject;

public abstract class Entity extends GameObject {
  protected Vec2 size;
  
  public Entity(float x,float y,float dx,float dy){
    position=new Vec2(x, y);
    size=new Vec2(dx, dy);
  }
}
