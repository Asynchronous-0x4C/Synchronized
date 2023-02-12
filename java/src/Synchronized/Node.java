package Synchronized;

import java.util.ArrayList;
import java.util.Arrays;

import Synchronized.GameObject.GameObject;
import Synchronized.Scene.Scene;

/**
 * Node is 
 */

public class Node<P,C extends GameObject> {
  private P parent;
  private ArrayList<C>childList;

  @SafeVarargs
  public Node(P parent,C... child){
    this.parent=parent;
    childList=new ArrayList<>(Arrays.asList(child));
  }

  public void addChild(C c){
    childList.add(c);
    if(parent instanceof Scene s){
      c.setRoot(s);
    }else if(parent instanceof GameObject o){
      c.setParent(o);
    }
  }

  @SafeVarargs
  public final void addChild(C... c){
    childList.addAll(Arrays.asList(c));
    if(parent instanceof Scene s){
      for(C variable:c)variable.setRoot(s);
    }else if(parent instanceof GameObject o){
      for(C variable:c)variable.setParent(o);
    }
  }

  public P getParent(){
    return parent;
  }

  public ArrayList<C> getChild(){
    return childList;
  }
}
