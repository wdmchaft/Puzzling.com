/**
 * Created by Peter Livesey.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// This function checks a request for the correct user authentication. It returns true if they are verified.

var noAuthenticationString = "no_auth_token_found";
var noAPIKeyString = "api_key_required";

exports.verifyRequestAuthtoken = function(req, res) {
	var puzzleAuth = req.headers.puzzle_auth_token;
	if (puzzleAuth == null) {
		res.statusCode = 401;
		res.send({ "error" : noAuthenticationString, "status" : 401 });
		return false;
	} else {
		return true;
	}
}

exports.verifyRequestAPIKey = function(req, res) {
	var puzzleAuth = req.headers.puzzle_api_key;
	if (puzzleAuth == null) {
		res.statusCode = 401;
		res.send({ "error" : noAPIKeyString, "status" : 401 });
		return false;
	} else {
		return true;
	}
}