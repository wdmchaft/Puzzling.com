package enemycomponents;

import bulletcomponents.Bullet;
import gamecomponents.*;

public class FireDude extends Enemy implements TDConstants {
	
	public FireDude(Path path, int h, int m) {
		super(path, h, m);
	}
	
	public int getType() { return FIRE_DUDE; }
	
	protected int calculateDamage(Bullet b) {
		if (b.getType() == FIRE_TOWER)
			return b.getDamage() / 2;
		if (b.getType() == ICE_TOWER)
			return 2 * b.getDamage() + 10;
		
		return b.getDamage();
	}
}