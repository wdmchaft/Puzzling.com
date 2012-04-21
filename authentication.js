/**
 * Created by Peter Livesey.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// These functions check for api keys and authtokens. They call a callback function when finished.

var db = require('./db');

var noAuthenticationString = "no_auth_token_found";
var incorrectAuthTokenString = "user_not_found";
var noAPIKeyString = "api_key_required";
var incorrectAPIString = "no_api_key_registered";

exports.verifyRequestAuthtokenAndAPI = function(req, res, callback) { //callback return bool success and a user when finished
	
	var authToken = req.headers.puzzle_auth_token;
	
	this.verifyRequestAPIKey(req, res, function(success) {
		if (!success) {
			callback(false);
		} else {
			var puzzleAuth = req.headers.puzzle_auth_token;
			if (puzzleAuth == null) {
				res.statusCode = 401;
				res.send({ "error" : noAuthenticationString, "statusCode" : 401 });
				callback(false);
			} else {
				db.UserModel.findOne({"authToken": authToken}, function(err, doc) {
					if (err) {
						res.statusCode = 500;
						res.send( { statusCode: 500, error : err} );
						callback(false);
					} else if (doc == null) {
						res.statusCode = 401; //Unauthorized
						res.send( { statusCode: 401, error : incorrectAuthTokenString } );
						callback(false);
					} else {
						callback(true, doc);
					}
				});
			}
		}
	});
};

exports.verifyRequestAPIKey = function(req, res, callback) { //callback returns bool success
	var puzzleAPI = req.headers.puzzle_api_key;
	if (puzzleAPI == null) {
		res.statusCode = 401;
		res.send({ "error" : noAPIKeyString, "statusCode" : 401 });
		callback(false);
	} else {
		callback(true);
	}
}