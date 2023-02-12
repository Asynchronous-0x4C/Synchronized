package Synchronized.GameObject.Block;

import org.jbox2d.common.Vec2;

import fisica.FBox;
import fisica.FWorld;
import processing.core.PApplet;

public class NormalBlock extends Block {
  
  public NormalBlock(float x,float y,FWorld w){
    super(x,y,w);
    initBody();
  }

  @Override
  public void initBody(){
    body=new FBox(40f, 40f);
    body.setPosition(position.x,position.y);
    body.setStatic(true);
    body.setRestitution(0f);
    world.add(body);
  }

  @Override
  protected void display(PApplet a){
    a.fill(40);
    a.noStroke();
    a.rectMode(PApplet.CENTER);
    a.rect(position.x,position.y,40f,40f);
  }

  @Override
  protected void update(){

  }

  @Override
  public Vec2 updatePosition() {
    return position;
  }
}
