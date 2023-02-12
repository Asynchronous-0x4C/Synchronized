package Synchronized;

import java.lang.reflect.Field;

import Synchronized.Input.Input;
import Synchronized.Scene.GameScene;
import Synchronized.Scene.Scene;
import Synchronized.Scene.SceneManager;
import fisica.Fisica;
import processing.core.PApplet;
import processing.event.KeyEvent;
import processing.event.MouseEvent;
import processing.opengl.PGraphicsOpenGL;

public class Synchronized extends PApplet{
  public static PApplet instance;

  private SceneManager sceneManager;
  private Scene scene;

  private float pTime;
  public static float deltaTime=16f;
  public static float deltaMag=1f;

  public static Input input;

  public static void main(String[]args){
    PApplet.main("Synchronized.Synchronized");
  }

  @Override
  public void settings(){
    windowRatio(1280, 720);
    size(1280, 720, P2D);
    instance=this;
    sceneManager=SceneManager.instance;
    input=Input.instance;
  }

  @Override
  public void setup(){
    Fisica.init(this);
    sceneManager.addScene(new GameScene());
    scene=sceneManager.setScene(0);
    try{
      Field f=PGraphicsOpenGL.class.getDeclaredField("textureSampling");
      f.setAccessible(true);
      f.set(g,2);
    }catch(Exception e){
      e.printStackTrace();
    }
  }

  @Override
  public void draw(){
    scene.update();
    scene.display(this);
    setFPSData();
    input.resetEvent();
  }

  private void setFPSData(){
    deltaTime=frameCount==1?16f:(System.nanoTime()-pTime)/1E6f;
    deltaMag=16f/deltaTime;
    pTime=System.nanoTime();
  }

  @Override
  public void keyPressed(KeyEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void keyReleased(KeyEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void keyTyped(KeyEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mousePressed(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseReleased(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseClicked(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseDragged(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseMoved(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseEntered(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseExited(MouseEvent e){
    input.HandleEvent(e);
  }

  @Override
  public void mouseWheel(MouseEvent e){
    input.HandleEvent(e);
  }
}
