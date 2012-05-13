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

var APIkeyModel = db.APIkeyModel
    , ObjectID = db.ObjectID;

// Verify only API key and not the auth token.
// Necessary for some operations for developers
// when they don't yet have tokens

function verifyRequestAPIKey(req, res, callback) { //callback returns bool success
    var puzzleKey = _u.stripNonAlphaNum(req.headers["puzzle_api_key"]);
    APIkeyModel.findById(puzzleKey.toString(), function (e, doc) {
        if (e || !doc) {
            if(e) console.log(e);
            err.sendError(err.notFound, res);
            callback(false);
        } else callback(true);
    });
}

// Verifies auth token + API.
function verifyRequestAuthTokenAndAPIKey(req, res, callback) {
	var authToken = req.headers["puzzle_auth_token"];
	verifyRequestAPIKey(req, res, function(success) {
		if (!success) {
            console.log("[auth] can't verify api key and auth token");
            err.sendError(err.notAuthenticated, res);
			callback(false);
		} else {
			var puzzleAuth = req.headers["puzzle_auth_token"];
			if (puzzleAuth == null) {
                console.log("[auth] can't verify api key and auth token");
				err.sendError(err.noAuthenticationString, res);
				callback(false);
			} else {
				db.UserModel.findOne({"authToken": authToken}, function(e, doc) {
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

// limited restriction function
function restrictByApi (req, res, next) {
    verifyRequestAPIKey(req, res, function(success, user) {
        // case !success is taken care of for us by
        // the authentication class
        if(success) {
            req.apiKey = req.headers["puzzle_api_key"];
            req.user = user;
            next();
        } else console.log("[auth] couldn't find api key " + req.headers["puzzle_api_key"]);
    });
}

//
// restrict user access
// and find and put 'user'
// 'apiKey', and 'authToken'
// fields into the request obj
//

function restrict (req, res, next) {
    verifyRequestAuthTokenAndAPIKey(req, res, function(success, user) {
        // case !success is taken care of for us by
        // the authentication class
        if(success) {
            req.apiKey = req.headers["puzzle_api_key"];
            req.authToken = req.headers["puzzle_auth_token"];
            req.user = user;
            next();
        } else console.log("[auth] couldn't find api key " + req.headers["puzzle_api_key"]
                            + " and matching auth token " + req.headers["puzzle_auth_token"]);
    });
}


/**
 * Exports
 */
exports.restrictByApi = restrictByApi;
exports.restrict = restrict;
exports.verifyApi = verifyRequestAPIKey;
exports.verifyRequestApiAuth = verifyRequestAuthTokenAndAPIKey;
