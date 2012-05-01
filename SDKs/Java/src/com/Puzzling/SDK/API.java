package com.Puzzling.SDK;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import android.net.Uri;
import android.util.Log;

import com.Puzzling.SDK.APIConfig.*;
import com.Puzzling.SDK.APIHttp;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.*;


public class API {

	/**
	 * Contains only static methods. Allows the user to choose his or her own
	 * bookkeeping for users. 
	 
	 * Modules:
	 * :: Login - Handling authentication, users, etc...
	 * :: Puzzle - Management of puzzle-handling process  
	 * :: JSON - Easy handling of JSON without the try/catch
	 * 
	 */
	
	public static final String loginPath = "login";
	public static final String puzzlePath = "puzzle";
	public static final String serverRoot = "http://10.0.2.2:3000";
	public static final String serverAuthority = "10.0.2.2:3000";
	
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
		 * One of the few methods taht doesn't require an auth token.
		 * @param u Username
		 * @param p Password
		 * @return JSONObject (subclass of java.util.Map) that contains fields
		 * relating to a typical user model (see User model in APIModels.java)
		 */
		public static JSONObject createUser(String u, String p, String userDataJSON) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("username", u));
			pairs.add(new BasicNameValuePair("password", p));
			pairs.add(new BasicNameValuePair("user_data", userDataJSON));
			String jsonResult = getJSONResponse("POST", serverRoot + loginPath, pairs);
			return JSON.parse(jsonResult);
		}
		
		/**
		 * Get auth token for user given a username and password
		 * Boils down essentially to a GET request to login url.
		 * This is one of the only methods that doesn't require an 
		 * auth token.
		 * @param u
		 * @param p
		 * @return String token; if none found, returns an empty string.
		 */
		public static String getAuthTokenForUser(String u, String p) {
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(loginPath);
			url.appendQueryParameter("username", u);
			url.appendQueryParameter("password", p);
			
			Log.i("API", url.toString());
			String jsonString = getJSONResponse("GET", url.toString(), null);
			JSONObject userObj = JSON.parse(jsonString);
			
			try {
				return userObj.getString("authToken");
			} catch (JSONException e) {
				return "";
			} catch (Exception e) {
				return "";
			}
		}
		
		/**
		 * Deletes user permanently, including all past records.
		 * This affects at most one user.
		 * @param u User to be deleted.
		 * @return True on success
		 */
		public static boolean deleteUser(String u, String authToken) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("username", u));
			pairs.add(new BasicNameValuePair("authToken", authToken));

			String jsonString = getJSONResponse("DELETE", serverRoot + loginPath, pairs);
			JSONObject successObj = JSON.parse(jsonString);
			
			try {
				return (successObj.getString("status").equalsIgnoreCase("SUCCESS"));
			} catch (JSONException e) {
				e.printStackTrace();
				return false;
			} catch (Exception e) {
				return false;
			}
		}
		
		/**
		 * Changes user password. Affects at most one user.
		 * @param u Target user
		 * @param p new password
		 * @return True on success
		 */
		public static boolean changeUserPassword(String u, String p, String authToken) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			pairs.add(new BasicNameValuePair("username", u));
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("password", p));
			
			String jsonString = getJSONResponse("PUT", serverRoot + loginPath, pairs);
			JSONObject successObj = JSON.parse(jsonString);
			
			try {
				return (successObj.getString("status").equalsIgnoreCase("SUCCESS"));
			} catch (JSONException e) {
				e.printStackTrace();
				return false;
			} catch (Exception e) {
				return false;
			}
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
			pairs.add(new BasicNameValuePair("username", u));
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("user_data", jsonData));
			String jsonString = getJSONResponse("PUT", serverRoot + loginPath, pairs);
			JSONObject successObj = JSON.parse(jsonString);
			
			try {
				return (successObj.getString("status").equalsIgnoreCase("SUCCESS"));
			} catch (JSONException e) {
				e.printStackTrace();
				return false;
			} catch (Exception e) {
				return false;
			}
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
			
			// Build url
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(puzzlePath);
			
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			// Request body
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("setupData", setupData));
			pairs.add(new BasicNameValuePair("solutionData", solutionData));
			pairs.add(new BasicNameValuePair("additionalData", additionalData));
			pairs.add(new BasicNameValuePair("puzzleType", puzzleType));
			
			String puzzleObj = getJSONResponse("POST", url.toString(), pairs);
			return JSON.parse(puzzleObj);
		}
	
		/**
		 * getPuzzlesForUser
		 * 
		 * Gets list of curated puzzles for a certain user.
		 * @param user
		 * @param authToken
		 * @return JSONArray of JSONObjects, each object representing a 
		 * puzzle object with certain fields.
		 */
		public static JSONArray getCuratedPuzzle(String user, String authToken) {
			// Build url
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(puzzlePath);
			url.appendPath(user);
			
			// Build Header
			List<NameValuePair> header = new ArrayList<NameValuePair>();
			header.add(new BasicNameValuePair("authToken", authToken));

			String jsonString = getJSONResponse("GET", url.toString(), header);
			return JSON.parseArray(jsonString);
			
		}
		
		/**
		 * Gets a specific puzzle object by the puzzle's ObjectID.
		 * @param puzzleId
		 * @return
		 */
		public static JSONObject getPuzzle(String puzzleId, String authToken) {
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(puzzlePath);
			url.appendPath(puzzleId);
			
			// Build Header
			List<NameValuePair> header = new ArrayList<NameValuePair>();
			header.add(new BasicNameValuePair("authToken", authToken));
			
			String jsonString = getJSONResponse("GET", url.toString(), header);
			return JSON.parse(jsonString);
		}
		
		/**
		 * Call this after a user takes a puzzle; 
		 * @param user_id: objectID of user who has just taken the puzzle.
		 * @param authToken: your auth token 
		 * @param puzzleID: objectID of puzzle that was just taken
		 * @param score: must b a number
		 * @return True if the request was successfully registered
		 */
		public static boolean takePuzzle(String user_id, String authToken, String puzzleID, Float score) {
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(puzzlePath);
			url.appendPath(user_id);
			
			// Build Header
			List<NameValuePair> header = new ArrayList<NameValuePair>();
			header.add(new BasicNameValuePair("authToken", authToken));
			
			String jsonString = getJSONResponse("POST", url.toString(), header);
			JSONObject successObj = JSON.parse(jsonString);
			return successObj.isNull("error");
		}

		/**
		 * Gets all puzzles made by certain user_id, which maps to an
		 * ObjectID in the backend.
		 * @param user_id
		 * @return JSONArray; each entry is a JSONObject representing
		 * a puzzle
		 */
		public static JSONArray getPuzzlesMadeByUser(String user_id) {
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(loginPath);
			url.appendPath("user");
			url.appendPath(user_id);
			String jsonString = getJSONResponse("GET", url.toString(), null);
			return JSON.parseArray(jsonString);
		}
		
		// v2
		
		/**
		 * v2
		 * Deletes specified puzzle, given user's auth token. We make sure that a
		 * user who is authenticating cannot delete the puzzle.
		 * @param puzzleId
		 * @param authToken
		 * @return True on success
		 
		public static boolean deletePuzzle(String puzzleId, String authToken) {
			List<NameValuePair> pairs = new ArrayList<NameValuePair>();
			// Request body
			pairs.add(new BasicNameValuePair("authToken", authToken));
			pairs.add(new BasicNameValuePair("puzzleId", puzzleId));
			
			Uri.Builder url = Uri.parse(serverRoot).buildUpon();
			url.appendPath(puzzlePath);
			String jsonString = getJSONResponse("DELETE", url.toString(), pairs);
			JSONObject successObj = JSON.parse(jsonString);
			
			try {
				return (successObj.getString("status").equalsIgnoreCase("SUCCESS"));
			} catch (JSONException e) {
				e.printStackTrace();
				return false;
			} catch (Exception e) {
				return false;
			}
		}
		*/
	}
	
	/* ---------------------------- Helper methods ---------------------------------- */
	
	public static class JSON {
		
		/* Helpful abstraction on top of existing Android JSON library 
		 * to help take care of annoying try/catches.
		 * Javascript-like functionality.
		 */
		
		// From JSON string 
		
		public static JSONArray parseArray(String json) {
			try {
				return new JSONArray(json);
			} catch (JSONException e) {
				e.printStackTrace();
				return new JSONArray();
			}
		}
		public static JSONObject parse(String json) {
			try {
				return new JSONObject(json);
			} catch (JSONException e) {
				e.printStackTrace();
				return new JSONObject();
			}
		}
		
		// To Json string  
		
		public static String stringify(JSONObject obj) {
			return obj.toString();
		}
		
		public static String stringify(JSONArray obj) {
			return obj.toString();
		}
	}
	
	/**
	 * Based on a URL, gets the JSON response as a string that can easily be
	 * transformed into JSON. In addition, if we ever find an authToken among
	 * the NameValuePairs in pairs, we put that in the header so that we can 
	 * authenticate this request.
	 * 
	 * @param method
	 * @param url
	 * @param pairs
	 * @return
	 */
	private static String getJSONResponse(String method, String url, List<NameValuePair> pairs) {
		
		// NOTE: If we ever find an "authToken" in the pairs passed in,
		// we know to add that as a header. This then takes care
		// of the server's authentication process, which require
		// auth tokens to be in the header.
		
		String response;
		List<NameValuePair> headers = new ArrayList<NameValuePair>(2);
		boolean withHeaders = true;
		
		// v1 : any puzzle_api_key works for now
		headers.add(new BasicNameValuePair("puzzle_api_key", "anything"));
		
		if(pairs != null) {
			for(NameValuePair pair : pairs) {
				if (pair.getName().equalsIgnoreCase("authToken")) {
					String authToken = pair.getValue();
					headers.add(new BasicNameValuePair("puzzle_auth_token", authToken));
				}
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
		
		return response;
	}
}
