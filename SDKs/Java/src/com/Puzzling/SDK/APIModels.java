package com.Puzzling.SDK;

import java.util.Date;

/**
 * Sample class with inner models mapping 1:1 to 
 * backend models on our MongoDB server.
 * These may be used for reference when parsing 
 * from a generic JSONObject or JSONArray of objects.
 * They may also be of help when creating GSON representation
 * of objects.
 * @author jimzheng
 *
 */

public class APIModels {
	
	public class User {
		String _id;
		String name;
		String password;
		String authToken;
		Integer rating;
		double rd;						/* rating deviation */
		String user_data;				/* JSON representation of additonal user data */
	}
	
	public class Puzzle {
		APIModels.User creator;			/* Foreignkey to user who created puzzle */
		
		String puzzleId; 				/* the unique _id for a puzzle */
		String meta;
		String setupData;
		String solutionsData;
		String type;
		int likes;
		int dislikes;
		int taken;						/* people who'v tkaen this puzzle */
		Date timestamp;
		double rating;
		double rd; 						/* rating deviation */
	}
	
	public class Comment {
		
	}
	
	public class Message {
		
	}
	
}
