package Synchronized.Scene;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;

public final class SceneManager {
  public static SceneManager instance=new SceneManager();
  private ArrayList<Scene>scenes;
  private int index=0;
  
  private SceneManager(){
    scenes=new ArrayList<>();
  }

  public void addScene(Scene s){
    scenes.add(s);
  }

  public void unloadScene(Scene s){
    if(scenes.indexOf(s)<=index)index--;
    scenes.remove(s);
  }

  public Scene loadScene(String path,String name){
    try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(path+name+".scene"))) {
        Scene s = (Scene) ois.readObject();
        scenes.add(s);
        return s;
    } catch (IOException | ClassNotFoundException e) {
        e.printStackTrace();
        return null;
    }
  }

  public void saveScene(String path,Scene s){
    try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(path+s.getName()+".scene"))){
      oos.writeObject(s);
    } catch (IOException e) {
        e.printStackTrace();
    }
  }

  public Scene setScene(Scene s){
    if(scenes.contains(s)){
      index=scenes.indexOf(s);
    }else{
      scenes.add(s);
      index=scenes.size()-1;
    }
    return getScene();
  }

  public Scene setScene(int i){
    if(scenes.size()<=i){
      index=scenes.size()-1;
    }else{
      index=i;
    }
    return getScene();
  }

  public Scene getScene(){
    return scenes.size()<1?null:scenes.get(index);
  }

  public int getIndex(){
    return index;
  }
}
