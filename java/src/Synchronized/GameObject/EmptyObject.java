package Synchronized.GameObject;

import org.jbox2d.common.Vec2;

import processing.core.PApplet;

/**
 * EmptyObject is a {@link GameObject} for a simple way to implementing Root GameObject.(By using {@link Node})
 */

public final class EmptyObject extends GameObject{
  
  public EmptyObject(){

  }

  @Override
  final protected void display(PApplet a){
    
  }

  @Override
  final protected void update(){
    
  }

  @Override
  public Vec2 updatePosition(){
    return position;
  }
}
