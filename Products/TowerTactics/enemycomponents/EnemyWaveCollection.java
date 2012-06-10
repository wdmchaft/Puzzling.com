/**
 * The EnemyWaveCollection stores the information for all of the waves
 * for a particular game.
 */

package enemycomponents;

import java.io.*;
import java.util.ArrayList;

import gamecomponents.TDConstants;

public class EnemyWaveCollection implements TDConstants {
	
	private ArrayList<EnemyWave> waveList;
	
	public EnemyWaveCollection() {
		waveList = new ArrayList<EnemyWave>();
		readFile();
	}
	
	private void readFile() {
		try {
			BufferedReader rd = new BufferedReader
				(new FileReader("waves/" + WAVE_NAME + ".w"));
			
			String line = rd.readLine();
			while (!line.equals("-----"))
				line = rd.readLine();
			
			EnemyWave wave = new EnemyWave();
			while (wave.readWave(rd)) {
				waveList.add(wave);
				wave = new EnemyWave();
			}
			
			rd.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public boolean wavesLeft() { return waveList.size() > 0; }
	public EnemyWave getNextWave() { return waveList.remove(0); }
}