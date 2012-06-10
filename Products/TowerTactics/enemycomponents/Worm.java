package enemycomponents;

import gamecomponents.*;

public class Worm extends Enemy implements TDConstants {
	
	public Worm(Path path, int h, int m) {
		super(path, h, m);
	}
	
	public int getType() { return WORM; }
}