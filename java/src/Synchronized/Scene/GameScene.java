package Synchronized.Scene;

import org.jbox2d.common.Vec2;

import Synchronized.GameObject.Camera;
import Synchronized.GameObject.Block.NormalBlock;
import Synchronized.GameObject.Entity.Character.PlayerCharacter;
import fisica.FWorld;
import processing.core.PApplet;

public class GameScene extends Scene{
  private FWorld world;
  private PlayerCharacter player;
  
  public GameScene(){
    super("GameScene");
    world=new FWorld();
    world.setGravity(new Vec2(0f, 125f));
    for(int i=0;i<10;i++)node.addChild(new NormalBlock(i*40f+20f,500f,world));
    for(int i=0;i<10;i++)node.addChild(new NormalBlock(400f+20f,300f+i*40f,world));
    player=new PlayerCharacter(20f, 0f, world);
    node.addChild(player);
    mainCamera=new Camera(player);
    player.getNode().addChild(mainCamera);
  }

  @Override
  public void display(PApplet a){
    a.background(0,175,255);
    displayChild(a);
  }

  @Override
  public void update(){
    world.step();
    updateChild();
  }
}
