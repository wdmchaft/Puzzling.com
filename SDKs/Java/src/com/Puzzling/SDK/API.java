package com.Puzzling.SDK;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import com.Puzzling.SDK.APIConfig.*;
import com.Puzzling.SDK.APIHttp;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONException;
import org.json.simple.JSONArray;
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
	public static final String serverRoot = "http://localhost:3000";
	
	public static JSONParser parser = new JSONParser();
	
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
		 * 
		 * 
		 * @param u Username
		 * @param p Password
		 * @return JSONObject (subclass of java.util.Map) that contains fields
		 * relating to a typical user model (see User model in APIModels.java)
		 */
		public static JSONObject createUser(String u, String p, String userDataJSON) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("password", p));
			pairs.add(new BasicNameValuePair("user_data", userDataJSON));
			JSONObject result = (JSONObject) getParseJSONResponse("POST", serverRoot + loginPath, pairs);
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
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("password", p));
			JSONObject result = (JSONObject) getParseJSONResponse("GET", serverRoot + loginPath, pairs);
			return (String) result.get("authToken");
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
			pairs.add(new BasicNameValuePair("authToken", authToken));
			JSONObject result = (JSONObject) getParseJSONResponse("DELETE", serverRoot + loginPath, pairs);
			String status = (String) result.get("status");
			return (status.equalsIgnoreCase("SUCCESS"));
		}
		
		/**
		 * Changes user password. Affects at most one user.
		 * @param u Target user
		 * @param p new password
		 * @return True on success
		 */
		public static boolean changeUserPassword(String u, String p, String authToken) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("password", p));
			JSONObject result = (JSONObject) getParseJSONResponse("PUT", serverRoot + loginPath, pairs);
			String status;
			status = (String) result.get("status");
			return (status.equalsIgnoreCase("SUCCESS"));
		}
		
		/**
		 * Change user data 
		 * @param u Username
		 * @param authToken Token obtained from logging in or creating user 
		 * @param jsonData new userdata to include.
		 * @return
		 */
		public static boolean changeUserData(String u, String authToken, String jsonData) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("name", u));
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("user_data", jsonData));
			JSONObject result = (JSONObject) getParseJSONResponse("PUT", serverRoot + loginPath, pairs);
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
		
		/**
		 * Create puzzle with specified parameters.
		 * Empty parameters may be denoted by empty string.
		 * 
		 * @param authToken: Required auth token obtained from user
		 * @param type: Required puzzle type. Think of it as a keyword for curation
		 * @param setupData: Required setup data.
		 * @param solutionData: Required solution data.
		 * @param additionalData: Optional extraneous
		 * @param puzzleType: Optional type.
		 * @return JSONObject representing the puzzle that was just created by
		 * the backend. Includes puzzleID as parameter. Use JSONObject's get("param1")
		 * method to get the parameters.
		 */
		public static JSONObject createPuzzle(String authToken, String type, 
										 String setupData, String solutionData,
										 String additionalData, String puzzleType) {
			
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			// Request body
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("setupData", setupData));
			pairs.add(new BasicNameValuePair("solutionData", solutionData));
			pairs.add(new BasicNameValuePair("additionalData", additionalData));
			pairs.add(new BasicNameValuePair("puzzleType", puzzleType));
			
			JSONObject result = (JSONObject) getParseJSONResponse("POST", serverRoot + puzzlePath, pairs);
			return result;
		}
		
		/**
		 * Deletes specified puzzle, given user's auth token. We make sure that a
		 * user who is authenticating cannot delete the puzzle.
		 * @param puzzleId
		 * @param authToken
		 * @return True on success
		 */
		public static boolean deletePuzzle(String puzzleId, String authToken) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			// Request body
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("puzzleId", puzzleId));
			
			JSONObject response = (JSONObject) getParseJSONResponse("POST", serverRoot + puzzlePath, pairs);
			String result = (String) response.get("status");
			return (result.equalsIgnoreCase("SUCCESS"));
		}
	
		/**
		 * Gets curated puzzles for given user.
		 * @param u
		 * @param authToken
		 * @return
		 */
		public static JSONArray getPuzzleForUser(String u, String authToken) {
			StringBuilder url =  new StringBuilder(serverRoot);
			url.append(puzzlePath).append("/").append(u);
			
			JSONArray result = (JSONArray) getParseJSONResponse("GET",url.toString(), null);
			return result;
		}
		
		/**
		 * Gets a specific puzzle object by ID.
		 * @param puzzleId
		 * @return
		 */
		public static JSONObject getPuzzle(String puzzleId) {
			StringBuilder url =  new StringBuilder(serverRoot);
			url.append(puzzlePath).append("/").append(puzzleId);
			JSONObject result = (JSONObject) getParseJSONResponse("GET",url.toString(), null);
			return result;
		}
		
		/**
		 * Call this when a user takes a puzzle; 
		 * @param user_id
		 * @param authToken
		 * @param puzzleID
		 * @param score
		 * @return
		 */
		public static boolean takePuzzle(String user_id, String authToken, String puzzleID, Float score) {
			StringBuilder url =  new StringBuilder(serverRoot);
			url.append(puzzlePath).append("/").append(user_id);
			JSONObject result = (JSONObject) getParseJSONResponse("POST", url.toString(), null);
			String status = (String) result.get("status");
			return (status.equalsIgnoreCase("SUCCESS"));
		}

		/**
		 * Gets all puzzles made by certain user_id. Useful for using
		 * @param user_id
		 * @return JSONArray; each entry is a JSONObject representing
		 * a 
		 */
		public static JSONArray getPuzzlesMadeByUser(String user_id) {
			StringBuilder url =  new StringBuilder(serverRoot);
			url.append(puzzlePath).append("/user/").append(user_id);
			JSONArray result = (JSONArray) getParseJSONResponse("GET",url.toString(), null);
			return result;
		}
	}
	
	/* ---------------------------- Helper methods ---------------------------------- */
	
	public static Object getParseJSONResponse(String method, String url, List<NameValuePair> pairs) {
		
		// Distinguish by method
		// If we ever find an "authToken" in the pairs passed in,
		// we know to add that as a header
		
		String response;
		List<NameValuePair> headers = null;
		boolean withHeaders = false;
		
		for(NameValuePair pair : pairs) {
			if (pair.getName().equalsIgnoreCase("authToken")) {
				String authToken = pair.getValue();
				withHeaders = true;
				if(headers == null) headers = new ArrayList<NameValuePair>();
				headers.add(new BasicNameValuePair("puzzle_auth_token", authToken));
			}
		}
		
		if(withHeaders) {
			
			if(method.equalsIgnoreCase("GET")) {
				response = APIHttp.getWithHeaders(url, headers);
			} else if(method.equalsIgnoreCase("POST")) {
				response = APIHttp.postWithHeaders(url, pairs, headers);
			} else if(method.equalsIgnoreCase("PUT")) {
				response = APIHttp.putWithHeaders(url, pairs, headers);
			} else if(method.equalsIgnoreCase("DELETE")) {
				response = APIHttp.deleteWithHeaders(url, pairs, headers);
			} else {
				return null;
			}
			
		} else {
		
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
		}
		
		// Parse and return data 
		try {
			return parser.parse(response);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		// Return an empty JSONObject so we avoid potential errors? 
		return null;
	}
}
