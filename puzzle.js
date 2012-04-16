/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

// Fake user database

var authentication = require('./authentication');
var url = require('url');

exports.create = function(req, res) {
	if (authentication.verifyRequestAuthtoken(req, res) && authentication.verifyRequestAPIKey(req, res)) {
		var authToken = req.headers.puzzle_auth_token;
		var apiKey = req.headers.puzzle_api_key;
		var setupData = req.body.setupData;
		var solutionData = req.body.solutionData;
		var additionalData = req.body.additionalData;
		var puzzleType = req.body.puzzleType;
		
		{ //this is the asynchronous method that edits the database
			var puzzleID = 142421321; //this should be fetched from the database (max(id)+1)
			var username = "ExampleUsername"; //this also needs to be fetched by the database using the authToken. Return error if doesn't exist.
			//Upload puzzle to database
			var returnValue = { "puzzle_id" : puzzleID, "created_by" : username, "insert more info here such as rating, timestamp, etc" : "moreInfo", "solutionData" : solutionData, "setupData" : setupData, "additionalData" : additionalData };
			res.send(returnValue);
		}
	}
};

exports.puzzleSuggestion = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res) && authentication.verifyRequestAuthtoken(req, res)) {
		
	}
};

exports.getPuzzle = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res)) { //this does not require an authtoken. should it?
		var puzzleID = req.params.id;
		{//this is the asynchronous method that edits the database
			var returnValue = { "puzzle_id" : puzzleID, "created_by" : "usrnm", "insert more info here such as rating, timestamp, solutiondata etc" : "moreInfo" }
			res.send(returnValue);
		}
	}
};

exports.getUserPuzzles = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res)) { //this doesn't need an api key
		var username = req.params.id;
		{//this is the asynchronous method that edits the database
			//get all puzzle ids where username = username
			var returnValue = [ 123213, 321314, 23121, 3231]; //list of puzzleids
			res.send(returnValue);
		}
	}
};

