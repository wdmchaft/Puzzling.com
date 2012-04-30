package com.Puzzling.SDK;
import junit.framework.TestCase;
import com.Puzzling.SDK.API.Login;
import org.json.simple.parser.*;

public class APITest extends TestCase {

	/* 
	 * Test login 
	 */
	public void testLogin() {
		String u = "puzzlingcomteam";
		String p = "password";
		
		String authtoken = Login.getAuthTokenForUser(u, p);
		Boolean success = Login.changeUserPassword(u, authtoken, p);
	}
	
	/* 
	 * Test puzzle creation
	 */
	public void testPuzzle() {
		
	}
	
	public void testUserInteraction() {
		
	}
	
}
