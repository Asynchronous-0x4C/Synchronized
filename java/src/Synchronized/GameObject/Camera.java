package Synchronized.GameObject;

import org.jbox2d.common.Vec2;

import processing.core.PApplet;

public class Camera extends GameObject{
  private GameObject target;
  public Vec2 offset;
  
  public Camera(GameObject target){
    super();
    this.target=target;
  }

  protected void display(PApplet a){}

  protected void update(){
    if(offset==null)offset=new Vec2(target.getWorldPosition());
    offset=offset.add(target.updatePosition().sub(offset).mul(0.5f));
  }

  @Override
  public Vec2 updatePosition(){
    position=target.position;
    return position;
  }
}
