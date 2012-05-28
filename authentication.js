/**
 * Created by Peter Livesey.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

/**
 * Requires
 */

var db = require('./db')
  , err = require('./error.js')
  , _u = require('./utils.js');

var APIkeyModel = db.APIkeyModel;

// kept here for historic reasons
// try to remove these if possible

exports.verifyApi = verifyApi;
exports.verifyRequestApiAUth = verifyRequestApiAuth;

// Verify only API key and not the auth token.
// Necessary for some operations for developers
// when they don't yet have tokens

function verifyApi (req, res, callback) { //callback returns bool success
    var puzzleKey = _u.stripNonAlphaNum(req.headers["puzzle_api_key"]);
    console.log("Verifying API key " + puzzleKey);
    APIkeyModel.findById(puzzleKey.toString(), function (e, doc) {
        if (e || !doc) {
            if(e) console.log(e);
            err.send_error(err.API_KEY, res);
            callback(false);
        } else callback(true);
    });
}

// Verifies auth token + API.
function verifyRequestApiAuth (req, res, callback) {
	verifyApi(req, res, function(success) {
		if (!success) {
			console.log("[auth] can't verify api key and auth token");
			callback(false);
		} else {
			var puzzleAuth = _u.stripNonAlphaNum(req.headers["puzzle_auth_token"]);
			console.log("Verifying auth token " + puzzleAuth);
			if (puzzleAuth == null) {
				console.log("[auth] can't verify api key and auth token");
				err.send_error(err.API_KEY, res);
				callback(false);
			} else {
				db.UserModel.findOne({"authToken": puzzleAuth}, function(e, doc) {
					if (e) {
                        console.log("[auth] can't verify api key and auth token");
						err.sendError(err.transactionError, res);
						callback(false);
					} else if (doc == null) {
                        console.log("[auth] can't verify api key and auth token");
                        err.sendError(err.incorrectAuthTokenString, res);
						callback(false);
					} else {
						callback(true, doc);
					}
				});
			}
		}
	});
}

///////////////////////////
//      Middleware      //
/////////////////////////

// limited restriction function
exports.restrictByApi =  function (req, res, next) {
    verifyApi(req, res, function(success, user) {
        // case !success is taken care of for us by
        // the authentication class
        if(success) {
            req.apiKey = _u.stripNonAlphaNum(req.headers["puzzle_api_key"]);
            req.user = user;
            next();
        } else console.log("[auth] couldn't find api key " + req.headers["puzzle_api_key"]);
    });
};

//
// restrict user access
// and find and put 'user'
// 'apiKey', and 'authToken'
// fields into the request obj
//

exports.restrict = function (req, res, next) {
    verifyRequestApiAuth(req, res, function(success, user) {
        // case !success is taken care of for us by
        // the authentication class
        if(success) {
            req.apiKey = _u.stripNonAlphaNum(req.headers["puzzle_api_key"]);
            req.authToken = _u.stripNonAlphaNum(req.headers["puzzle_auth_token"]);
            req.user = user;
            next();
        } else console.log("[auth] couldn't find api key " + req.headers["puzzle_api_key"]
                            + " and matching auth token " + req.headers["puzzle_auth_token"]);
    });
};