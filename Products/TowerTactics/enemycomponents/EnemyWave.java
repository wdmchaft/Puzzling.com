package enemycomponents;

import java.io.*;
import java.util.*;

import gamecomponents.*;

public class EnemyWave implements TDConstants {
	
	private String name;
	private ArrayList<EnemyWaveEntry> enemyList;
	private int waveCounter;
	
	public EnemyWave() {
		waveCounter = 0;
		enemyList = new ArrayList<EnemyWaveEntry>();
	}
	
	public boolean readWave(BufferedReader rd) {
		try {
			name = rd.readLine();
			if (name == null || name.equals("")) return false;
			
			String line = rd.readLine();
			while (line != null && !line.equals("")) {
				StringTokenizer tk = new StringTokenizer(line, "x");
				String entry = tk.nextToken().trim();
				enemyList.add(new EnemyWaveEntry(entry));
				
				if (tk.hasMoreTokens()) {
					int count = Integer.parseInt(tk.nextToken().trim());
					for (int i = 1; i < count; i++)
						enemyList.add(new EnemyWaveEntry(entry));
				}
				
				line = rd.readLine();
			}
			
			return true;
		} catch (Exception e) { 
        	e.printStackTrace();
        	return false;
		}
	}
	
	public static class EnemyWaveEntry {
		
		public int type, health, money, timer;
		
		public EnemyWaveEntry(String line) {
			StringTokenizer tk = new StringTokenizer(line);
			
			type = Integer.parseInt(tk.nextToken());
			if (type < 0 || type > LAST_ENEMY_TYPE)
				type = (int) (Math.random() * (LAST_ENEMY_TYPE + 1));
			
			health = Integer.parseInt(tk.nextToken());
			money = Integer.parseInt(tk.nextToken());
			timer = Integer.parseInt(tk.nextToken());
		}
	}
	
	public String getName() { return name; }
	public boolean enemiesLeft() { return enemyList.size() > 0; }
	
	public Enemy generateEnemy(Path path) {
		if (isNextEnemyTime()) {
			EnemyWaveEntry entry = enemyList.remove(0);
			return Enemy.getEnemy(path, entry.type, entry.health, entry.money);
		}
		
		return null;
	}
	
	private boolean isNextEnemyTime() {
		EnemyWaveEntry entry = enemyList.get(0);
		if (entry.timer <= waveCounter++) {
			waveCounter = 0;
			return true;
		}
		
		return false;
	}
}