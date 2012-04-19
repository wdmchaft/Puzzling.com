/**
 * Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

var authentication = require('./authentication');
var url = require('url');
var glicko = require('./glicko');
var db = require('./db');

exports.create = function(req, res) {
	if (authentication.verifyRequestAuthtoken(req, res) && authentication.verifyRequestAPIKey(req, res)) {
		var authToken = req.headers.puzzle_auth_token;
		var apiKey = req.headers.puzzle_api_key;
		var setupData = req.body.setupData;
		var solutionData = req.body.solutionData;
		var additionalData = req.body.additionalData;
		var puzzleType = req.body.puzzleType;
		var puzzleName = req.body.name;
		var puzzleType = req.body.type;
		
		var puzzleInstance = new db.puzzleModel();
		puzzleInstance.name = puzzleName;
		puzzleInstance.creator = "peter";
		puzzleInstance.data = setupData;
		puzzleInstance.solution = solutionData;
		puzzleInstance.type = puzzleType;
		puzzleInstance.likes = 0;
		puzzleInstance.dislikes = 0;
		puzzleInstance.taken = 0;
		puzzleInstance.timestamp = new Date();
		puzzleInstance.rating = 1500;
		
		
	}
};

exports.puzzleSuggestion = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res) && authentication.verifyRequestAuthtoken(req, res)) {
		var authToken = req.headers.puzzle_auth_token;
		var apiKey = req.headers.puzzle_api_key;
		
	}
};

exports.getPuzzle = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res)) { //this does not require an authtoken. should it?
		var puzzleID = req.params.id;
		var apiKey = req.headers.puzzle_api_key;
		{//this is the asynchronous method that edits the database
			//make sure to verify api key
			var returnValue = { "puzzle_id" : puzzleID, "created_by" : "usrnm", "insert more info here such as rating, timestamp, solutiondata etc" : "moreInfo" }
			res.send(returnValue);
		}
	}
};

exports.getUserPuzzles = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res)) { //this doesn't need an api key
		var username = req.params.id;
		var apiKey = req.headers.puzzle_api_key;
		{//this is the asynchronous method that edits the database
			//make sure to verify api key
			//get all puzzle ids where username = username
			var returnValue = [123213, 321314, 23121, 3231]; //list of puzzleids
			res.send(returnValue);
		}
	}
};

exports.takePuzzle = function(req, res) {
	if (authentication.verifyRequestAPIKey(req, res) && authentication.verifyRequestAuthtoken(req, res)) {
		var puzzleID = req.params.id;
		var apiKey = req.headers.puzzle_api_key;
		{//this is the asynchronous method that edits the database
			//make sure to verify api key
			//enter the data
			//update rating.
			var playerRating = 1500;
			var puzzleRating = 1500;
			var playerRD = 350;
			var puzzleRD = 30;
			var score = 1;
			var newPlayerRating = glicko.newRating(playerRating, puzzleRating, playerRD, puzzleRD, score);
			var newPuzzleRating = glicko.newRating(puzzleRating, playerRating, puzzleRD, playerRD, 1-score);
			var newPlayerRD = glicko.newRD(playerRating, puzzleRating, playerRD, puzzleRD, score, false);
			var newPuzzleRD = glicko.newRD(puzzleRating, playerRating, puzzleRD, playerRD, 1-score, true);
			var returnValue = { "newPlayerRating" : newPlayerRating, "newPuzzleRating" : newPuzzleRating, "newPlayerRD": newPlayerRD, "newPuzzleRD" : newPuzzleRD };
			res.send(returnValue);
		}
	}
}

