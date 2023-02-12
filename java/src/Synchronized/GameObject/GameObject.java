package Synchronized.GameObject;

import java.util.ArrayList;

import org.jbox2d.common.Vec2;

import Synchronized.Node;
import Synchronized.Scene.Scene;
import processing.core.PApplet;

/**
 * GameObject is the base class to implement Character, Object, Bullet etc...
 */

public abstract class GameObject {
  protected final Node<GameObject,GameObject>node=new Node<>(this);
  protected GameObject parent;
  protected Vec2 position=new Vec2();
  protected Vec2 worldPosition=new Vec2();
  protected Vec2 velocity=new Vec2();
  private String name;
  private boolean isRoot=false;
  private boolean active=true;

  public final void callDisplay(PApplet a){
    if(isActive()){
      display(a);
      displayChild(a);
    }
  }

  protected abstract void display(PApplet a);

  public final void callUpdate(){
    if(isActive()){
      update();
      updateChild();
    }
  }

  protected abstract void update();

  public abstract Vec2 updatePosition();

  public void setName(String s){
    name=s;
  }

  public String getName(){
    return name;
  }

  public boolean isActive(){
    return active;
  }

  public void setActive(boolean active){
    this.active=active;
  }

  public Node<GameObject,GameObject> getNode(){
    return node;
  }

  public ArrayList<GameObject> getChild(){
    return node.getChild();
  }

  protected void displayChild(PApplet a){
    a.pushMatrix();
    a.translate(position.x,position.y);
    getChild().forEach(o->o.callDisplay(a));
    a.popMatrix();
  }

  protected void updateChild(){
    getChild().forEach(o->o.callUpdate());
  }

  public void setParent(GameObject o){
    parent=o;
  }

  public void setRoot(Scene s){
    isRoot=s.getNode().getChild().contains(this);
  }

  public boolean isRoot(){
    return isRoot;
  }

  public Vec2 getWorldPosition(){
    if(isRoot){
      worldPosition.set(position);
    }else{
      worldPosition.set(position.add(parent.getWorldPosition()));
    }
    return worldPosition;
  }
}
