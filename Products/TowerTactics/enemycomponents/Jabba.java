package enemycomponents;

import bulletcomponents.Bullet;
import gamecomponents.*;

public class Jabba extends Enemy implements TDConstants {
	public Jabba(Path path, int h, int m) {
		super(path, h, m);
	}
	
	public int getType() { return JABBA; }
	
	protected int calculateDamage(Bullet b) {
		if (b.getType() == SNIPER_TOWER)
			return 2 * b.getDamage();
		
		return b.getDamage();
	}
}