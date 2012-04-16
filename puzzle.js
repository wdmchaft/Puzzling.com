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
}

