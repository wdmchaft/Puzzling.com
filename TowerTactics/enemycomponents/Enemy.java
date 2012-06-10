/**
 * The abstract Enemy class describes methods common to the various enemies
 * that appear throughout the game.
 */
package enemycomponents;

import acm.graphics.*;
import gamecomponents.*;
import bulletcomponents.Bullet; 

public abstract class Enemy implements TDConstants {
	
	protected static final int TIMER = 3;
	
	/*
	 * - lastCorner is the index of the last path corner the enemy reached.
	 * - preHealth keeps track of the enemy's health; it is different from the
	 *   ordinary health variable in that it updates the moment the tower
	 *   targets it, rather than when the bullet strikes. This tells the towers
	 *   whether or not they need to fire at an enemy close to death.
	 */
	private int lastCorner;
	private int direction;
	private int health, preHealth;
	private int money;
	private GCompound image;
	
	/*
	 * freezeCount starts at -1 when the enemy isn't frozen. When it is,
	 * the variable starts at 0 and increments until it reaches
	 * freezeLength, at which time the enemy is unfrozen.
	 */
	private double freezeRate;
	private int freezeCount, freezeLength;
	
	public Enemy(Path path, int h, int m) {
		lastCorner = 0;
		direction = path.getDirection(lastCorner);
		health = h;
		preHealth = h;
		money = m;
		
		image = new GCompound();
		image.add(new GImage("enemies/e" + getType() + "-" + direction + ".png"));
		
		freezeCount = -1;
	}
	
	public abstract int getType();
	public GCompound getImage() { return image; }
	
	// Adjusts the point on the enemy at which the bullets aim:
	
	public double aimX() {
		switch (direction) {
		case RIGHT:
			return image.getX() + 50;
		case LEFT:
			return image.getX() - 10;
		default:
			return image.getX() + 20;
		}
	}
	
	public double aimY() {
		switch (direction) {
		case DOWN:
			return image.getY() + 50;
		case UP:
			return image.getY() - 10;
		default:
			return image.getY() + 20;
		}
	}
	
	
	// Checks to see whether or not the enemy is scheduled to move and
	// updates its frozen state:
	public boolean checkTime(int time) {
		if (isFrozen()) {
			freezeCount++;
			if (freezeCount >= freezeLength) {
				freezeRate = 0;
				freezeCount = -1;
				freezeLength = 0;
				image.remove(image.getElementAt(20, 20));
			}
		}
		
		return time % (TIMER + freezeRate) == 0;
	}
	
	public boolean isFrozen() { return freezeCount != -1; }
	
	
	// Moves the enemy based on its direction, and checks for turning:
	public boolean move(Path path) {
		switch(direction) {
		case RIGHT:
			image.move(2, 0);
			break;
		case UP:
			image.move(0, -2);
			break;
		case LEFT:
			image.move(-2, 0);
			break;
		default:
			image.move(0, 2);
			break;
		}
		
		return checkPath(path);
	}
	

	private boolean checkPath(Path path) {
		Cell current = Cell.snapToGrid(getTailX(), getTailY());
		if (path.atNextCorner(current, lastCorner)) {
			lastCorner++;
			if (path.atLastCorner(lastCorner)) return true;
			direction = path.getDirection(lastCorner);
			
			if (isFrozen())
				image.remove(image.getElementAt(20, 20));
			
			GImage img = (GImage) image.getElementAt(20, 20);
			img.setImage("enemies/e" + getType() + "-" + direction + ".png");
			
			if (isFrozen())
				image.add(new GImage("enemies/f" + direction + ".png"));
		}
		
		return false;
	}
	
	private double getTailX() {
		switch (direction) {
		case RIGHT: return image.getX();
		case LEFT: return image.getX() + SPACING;
		default: return image.getX() + SPACING / 2;
		}
	}
	
	private double getTailY() {
		switch (direction) {
		case UP: return image.getY() + SPACING;
		case DOWN: return image.getY();
		default: return image.getY() + SPACING / 2;
		}
	}
	

	// When hit by an ice bullet:
	public void freeze(int fr, int fl) {
		if (!isFrozen()) {
			image.add(new GImage("enemies/f" + direction + ".png"));
			freezeCount = 0;
		}
		
		freezeRate = Math.max(fr, freezeRate);
		freezeLength += fl;
	}
	

	// When hit by a fire bullet:
	public void heat(int afl) {
		if (isFrozen())	freezeCount += afl;
	}
	
	public boolean isAlive() {
		return preHealth > 0;
	}
	
	public void takePreDamage(Bullet b) {
		preHealth -= calculateDamage(b);
	}
	
	public void takeDamage(TDInterface td, Bullet b) {
		health -= calculateDamage(b);
		checkHealth(td);
	}
	

	// This class can be overriden by subclasses that take damage differently:
	protected int calculateDamage(Bullet b) {
		return b.getDamage();
	}
	
	private void checkHealth(TDInterface td) {
		 if (health <= 0) {
			 td.gainMoney(money);
			 td.addKill();
			 td.updateStats();
			 
			 td.removeEnemy(this);
			 td.getDisplay().remove(image);
		 }
	}
	
	// TODO update when enemies added
	public static Enemy getEnemy(Path path, int type, int health, int money) {
		switch (type) {
		case WORM: return new Worm(path, health, money);
		case JABBA: return new Jabba(path, health, money);
		case FIRE_DUDE: return new FireDude(path, health, money);
		case ICE_DUDE: return new IceDude(path, health, money);
		default: return null;
		}
	}
}