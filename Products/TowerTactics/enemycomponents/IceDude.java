package enemycomponents;

import bulletcomponents.Bullet;
import gamecomponents.*;

public class IceDude extends Enemy implements TDConstants {
	
	public IceDude(Path path, int h, int m) {
		super(path, h, m);
	}
	
	public int getType() { return ICE_DUDE; }
	
	protected int calculateDamage(Bullet b) {
		if (b.getType() == FIRE_TOWER)
			return 2 * b.getDamage();
		
		return b.getDamage();
	}
	
	@Override
	public boolean checkTime(int time) {
		return time % TIMER == 0;
	}
	
	@Override
	public boolean isFrozen() { return false; }
	
	@Override
	public void freeze(int fr, int fl) { }
	
	@Override
	public void heat(int afl) { }
}