package com.Puzzling.SDK;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import com.Puzzling.SDK.APIConfig.*;
import com.Puzzling.SDK.APIHttp;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.simple.JSONObject;
import org.json.simple.parser.*;

public class API {

	/**
	 * Contains only static methods. Allows the user to choose his or her own
	 * bookkeeping for users. 
	 * Modules:
	 * :: Login
	 * :: Puzzle
	 */
	
	public static final String loginPath = "/login";
	public static final String puzzlePath = "/puzzle";
	public static final String serverRoot = APIConfig.serverRoot;
	
	public API() {/* placeholder */}
	
	/*
	 * Represent all backend models with ability to connect to 
	 * them here.
	 */

	/** Login Object
	 * Static methods for authenticating. Save these to your own application's
	 * data structures.
	 */
	public static class Login {

		/**
		 * Create username with given password and user info.
		 * User data passed in as JSON. The user is free to use
		 * any JSON library to create userDataJSON; all we require
		 * is that the user add the small JSON-simple library
		 * to deal with most things.
		 * @param u Username
		 * @param p Password
		 * @return True on success
		 */
		public static JSONObject createUser(String u, String p, String userDataJSON) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("password", p));
			pairs.add(new BasicNameValuePair("user_data", userDataJSON));
			JSONObject result = getParseJSONResponse("POST", serverRoot + loginPath, pairs);
			return result;
		}
		
		/**
		 * Get auth token for user given a username and password
		 * Boils down essentially to a GET request to login url
		 * @param u
		 * @param p
		 * @return String token
		 */
		public static String getAuthTokenForUser(String u, String p) {
			JSONObject result = getParseJSONResponse("GET", serverRoot + loginPath, null);
			return (String) result.get("authtoken");
		}
		
		/**
		 * Deletes user permanently, including all past records.
		 * This affects at most one user.
		 * @param u User to be deleted.
		 * @return True on success
		 */
		public static boolean deleteUser(String u, String authToken) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("authtoken", authToken));
			JSONObject result = getParseJSONResponse("DELETE", serverRoot + loginPath, pairs);
			String status = (String) result.get("status");
			return (status.equalsIgnoreCase("SUCCESS"));
		}
		
		/**
		 * Changes user password. Affects at most one user.
		 * @param u Target user
		 * @param p new password
		 * @return True on success
		 */
		public static boolean changeUserPassword(String u, String authToken, String p) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("authtoken", authToken));
			pairs.add(new BasicNameValuePair("password", p));
			JSONObject result = getParseJSONResponse("PUT", serverRoot + loginPath, pairs);
			String status;
			status = (String) result.get("status");
			return (status.equalsIgnoreCase("SUCCESS"));
		}
		
		/**
		 * Change user data 
		 * @param u
		 * @param jsonData
		 * @return
		 */
		public static boolean changeUserData(String u, String authToken, String jsonData) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("authtoken", authToken));
			JSONObject result = getParseJSONResponse("PUT", serverRoot + loginPath, pairs);
			String status = (String) result.get("status");
			return (status.equalsIgnoreCase("SUCCESS"));
		}
	}
	
	/**
	 * Puzzles
	 * 
	 * Encapsulates both user interactions of puzzle, puzzle creation, and other
	 * methods that interact with our API.
	 * 
	 * @author jimzheng
	 */
	public static class Puzzle {
		public static boolean createPuzzle(String authtoken, String type, 
										 String setupData, String solutionData,
										 String additionalData, String puzzleType) {
			
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			// Body txt
			pairs.add(new BasicNameValuePair("authtoken", authtoken));
			pairs.add(new BasicNameValuePair("setupData", setupData));
			pairs.add(new BasicNameValuePair("solutionData", solutionData));
			pairs.add(new BasicNameValuePair("additionalData", additionalData));
			pairs.add(new BasicNameValuePair("puzzleType", puzzleType));
			
			JSONObject result = getParseJSONResponse("POST", serverRoot + puzzlePath, pairs);
			String status = (String) result.get("status");
			return false;
		}
		
		public static boolean updateSetupData(String authToken, String puzzleID, String setupData) {
		
		}
		
		public static boolean updateSolutionData(String authToken, String puzzleID, String setupData) {
			
		}
		
		public static boolean updateAdditionalData(String authToken, String puzzleID, String setupData) {
			
		}
		
		public static boolean amendToAdditionalData() {
			
		}
		
		public static boolean deletePuzzle() {
			
		}
	
		public static boolean getPuzzleForUser(String u) {
			
		}
		
		public static void setOptions(String u) {
			
		}
		
		public static boolean getPuzzle(Integer puzzleId) {
			
		}
		
		public static JSONArray getComments() {
			
		}
		
		public static JSONArray getPuzzlesMadeByUser() {
			
		}
		
		public static void takePuzzle(String authToken, String puzzleID, Float score) {
			
		}
		
		public static void commentOnPuzzle(String authToken, String puzzleID, String comment) {
			
		}
		
		public static String getExtraInfoForUser(String u) {
			
		}
		
		public static boolean sendFriendRequest(String authtoken, String u) {
			
		}
		
		public static JSONArray getFriendRequests(String authtoken, String u) {
			
		}
		
		public static boolean acceptFriendRequest(String authtoken, String u) {
			
		}
		
		public static boolean sendMessage(String authtoken, String u, String msg ) {
			
		}
		
		public static JSONArray getMessages(String u) {
			
		}
		
		public static void deleteMessage(Integer messageId) {
			
		}
		
	}
	
	/* ---------------------------- Helper methods ---------------------------------- */
	
	public static JSONObject getParseJSONResponse(String method, String url, List<NameValuePair> pairs) {
		// Distinguish by method
		String response;
		if(method.equalsIgnoreCase("GET")) {
			response = APIHttp.get(url);
		} else if(method.equalsIgnoreCase("POST")) {
			response = APIHttp.post(url, pairs);
		} else if(method.equalsIgnoreCase("PUT")) {
			response = APIHttp.put(url, pairs);
		} else if(method.equalsIgnoreCase("DELETE")) {
			response = APIHttp.delete(url, pairs);
		} else {
			return null;
		}
		// Parse and return data 
		JSONObject result;
		try {
			result = (JSONObject) APIConfig.parser.parse(response);
			return result;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}
}
