package Synchronized.GameObject.Entity.Character;

import processing.core.PApplet;

public enum Direction {
  Right(PApplet.RIGHT),
  Left(PApplet.LEFT),
  Up(PApplet.UP),
  Down(PApplet.DOWN);
  
  private int num;
  
  Direction(int i){
    num=i;
  }
  
  int intValue(){
    return num;
  }
}
