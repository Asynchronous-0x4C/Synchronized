package Synchronized.GameObject.Entity.Character;

public interface StateBase {
  public int getStrength();

  public boolean isStrong(StateBase s);

  public StateBase getStateBase();
}
