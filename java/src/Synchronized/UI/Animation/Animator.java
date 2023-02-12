package Synchronized.UI.Animation;

import java.util.function.BiConsumer;

import Synchronized.Synchronized;

public class Animator {
  private BiConsumer<Float,Float>process;
  private boolean loop=true;
  private float cumlativeTime=0;
  private float mag=1;
  
  public Animator(BiConsumer<Float,Float>arg){
    process=arg;
  }
  
  public void animate(){
    if(!loop)return;
    process.accept(cumlativeTime,Synchronized.deltaTime);
    cumlativeTime+=Synchronized.deltaTime*mag;
  }
  
  public void setMagnification(float mag){
    this.mag=mag;
  }
  
  public void resetCumlativeTime(){
    cumlativeTime=0;
  }
  
  public void stop(){
    loop=false;
  }
  
  public boolean isLoop(){
    return loop;
  }
  
  public void start(){
    loop=true;
  }
}
