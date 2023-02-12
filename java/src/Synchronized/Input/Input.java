package Synchronized.Input;

import java.util.ArrayList;
import java.util.HashSet;

import processing.event.KeyEvent;
import processing.event.MouseEvent;

public class Input {
  public static Input instance=new Input();

  private ArrayList<KeyEvent>keyEvents;
  private ArrayList<MouseEvent>mouseEvents;

  private HashSet<Integer>keyCodes;
  private HashSet<Integer>mouseButtons;

  private Input(){
    keyEvents=new ArrayList<>();
    mouseEvents=new ArrayList<>();
    keyCodes=new HashSet<>();
    mouseButtons=new HashSet<>();
  }

  public HashSet<Integer> getPressingKeyCode(){
    return keyCodes;
  }

  public boolean getKey(int i){
    return keyCodes.contains((Integer)i);
  }

  public boolean getKeyDown(int i){
    for(KeyEvent e:keyEvents){
      if(e.getAction()==KeyEvent.PRESS&&e.getKeyCode()==i){
        return true;
      }
    }
    return false;
  }

  public boolean getKeyUp(int i){
    for(KeyEvent e:keyEvents){
      if(e.getAction()==KeyEvent.RELEASE&&e.getKeyCode()==i){
        return true;
      }
    }
    return false;
  }

  public HashSet<Integer> getPressingMouseButton(){
    return mouseButtons;
  }

  public boolean getMouseButton(int i){
    return mouseButtons.contains((Integer)i);
  }

  public boolean getMouseButtonDown(int i){
    for(MouseEvent e:mouseEvents){
      if(e.getAction()==MouseEvent.PRESS&&e.getButton()==i){
        return true;
      }
    }
    return false;
  }

  public boolean getMouseButtonUp(int i){
    for(MouseEvent e:mouseEvents){
      if(e.getAction()==KeyEvent.RELEASE&&e.getButton()==i){
        return true;
      }
    }
    return false;
  }

  public void resetEvent(){
    keyEvents.clear();
    mouseEvents.clear();
  }

  public void HandleEvent(KeyEvent e){
    switch(e.getAction()){
      case KeyEvent.PRESS->keyCodes.add((Integer)e.getKeyCode());
      case KeyEvent.RELEASE->keyCodes.remove((Integer)e.getKeyCode());
      case KeyEvent.TYPE->keyCodes.add((Integer)e.getKeyCode());
    }
    keyEvents.add(e);
  }

  public void HandleEvent(MouseEvent e){
    switch(e.getAction()){
      case MouseEvent.PRESS->mouseButtons.add((Integer)e.getButton());
      case MouseEvent.RELEASE->mouseButtons.remove((Integer)e.getButton());
      case MouseEvent.CLICK->mouseButtons.add((Integer)e.getButton());
    }
    mouseEvents.add(e);
  }
}
