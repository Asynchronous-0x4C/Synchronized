package Synchronized.GameObject.Entity.Character;

import java.util.ArrayList;

import Synchronized.Synchronized;
import Synchronized.UI.Animation.Animator;
import processing.core.PImage;

public class State {
  private ArrayList<PImage>images;
  private PImage nowImage;
  private Animator anim;
  private Runnable end=()->{};
  private boolean run=true;
  private int maxLoop=-1;
  private int loopNum;
  private int num;
  
  /**
   * 
   * @param duration The time to change next image.
   * @param directry Image source directry(under src\Synchronized\resources\)
   * @param names Image source name([name]_[state]_[direction])
   * @param frame The number of image sources.
   * @param ext File extension name(.png .jpg etc...)
   */
  public State(float duration,String directry,String names,int frame,String ext){
    images=new ArrayList<>();
    for(int i=0;i<frame;i++){
      images.add(Synchronized.instance.loadImage("java\\src\\Synchronized\\resources\\"+directry+names+(frame==1?"":"_"+i)+ext));
    }
    nowImage=images.get(0);
    num=0;
    anim=new Animator((cum,millis)->{
      run=true;
      if(cum>duration*(1+num)){
        num++;
        if(num>=images.size()){
          anim.resetCumlativeTime();
          loopNum++;
          if(maxLoop!=-1&&loopNum>=maxLoop){
            run=false;
            end.run();
          }
          if(run){
            num=0;
          }
        }
        if(run)this.setImage(images.get(num));
      }
    });
  }
  
  public State(float duration,int maxLoop,Runnable end,String directry,String names,int num,String ext){
    this(duration,directry,names,num,ext);
    this.end=end;
    this.maxLoop=maxLoop;
  }
  
  public void update(){
    
    anim.animate();
  }
  
  private void setImage(PImage i){
    nowImage=i;
  }
  
  public PImage getImage(){
    return nowImage;
  }
  
  public void rewind(){
    loopNum=num=0;
    anim.resetCumlativeTime();
    this.setImage(images.get(0));
    anim.start();
  }
}
