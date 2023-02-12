package Synchronized.Scene;

import java.io.Serializable;
import java.util.ArrayList;

import org.jbox2d.common.Vec2;

import Synchronized.Node;
import Synchronized.GameObject.Camera;
import Synchronized.GameObject.GameObject;
import processing.core.PApplet;

public abstract class Scene implements Serializable{
  protected Camera mainCamera;
  private String name;
  protected final Node<Scene,GameObject>node=new Node<>(this);
  public abstract void display(PApplet a);

  public abstract void update();

  public Scene(String name){
    this.name=name;
  }

  public String getName(){
    return name;
  }

  public void addChild(GameObject... o){
    node.addChild(o);
  }

  public Node<Scene,GameObject> getNode(){
    return node;
  }

  public ArrayList<GameObject> getChild(){
    return node.getChild();
  }

  public void displayChild(PApplet a){
    Vec2 p=mainCamera.offset;
    a.translate(-p.x+a.rwidth*0.5f, -p.y+a.rheight*0.5f);
    getChild().forEach(o->o.callDisplay(a));
  }

  public void updateChild(){
    getChild().forEach(o->o.callUpdate());
  }
}
