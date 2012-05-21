/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 5/1/12
 * Time: 3:54 AM
 * To change this template use File | Settings | File Templates.
 */

/*
 * Error codes defined here.
 */

exports.UNKNOWN_ERROR = 0;
exports.NO_PASSWORD = 1;
exports.NO_USER = 2;
exports.EXISTS_USER = 3;
exports.NO_MATCHING_USER = 4; //only return for userids
exports.INVALID_AUTHTOKEN = 5;
exports.DB_ERROR = 6;
exports.NO_PUZZLES = 7;
exports.PUZZLE_DOESNT_EXIST = 8;
// users
exports.noPassword= "no_password_exists";
exports.noUser = "no_username_exists";
exports.existsUser = "user_exists";
exports.noMatchingUser= "no_such_user_exists";
exports.notAuthenticated= "not_authenticated";
exports.missingInfo= "missing_parameters";
// Auth
exports.noAuthenticationString = "no_auth_token_found";
exports.incorrectAuthTokenString = "user_not_found";
exports.noAPIKeyString = "api_key_required";
// Generic errors
exports.notFound = "not_found";
exports.updateError = "error_updating";
exports.badOperation = "no_such_operation";
exports.transactionError = "transaction_could_not_be_processed";

//Got bored…add these as needed
//exports.BAD_OP = "no_such_operation";
//exports.NOT_FOUND = "not_found";
//exports.UPDATE_ERROR = "error_updating";
//exports.NOT_AUTHENTICATED = "not_authenticated";
//exports.MISSING_INFO = "missing_parameters";

//Codes
AUTHENTICATION = 401;
METHOD_NOT_ALLOWED = 405;
INTERNAL_SERVER = 500;

exports._500_Errors = [this.transactionError];

/*
 * Sends JSON formatted error code back to the user.
 * Message can be any of the above, or a custom string.
 */
exports.send_error = function send_error(errorType, res, dbMessage) { //last param optional
    switch(errorType) 
		{
		case this.NO_PASSWORD:
			res.statusCode = AUTHENTICATION;
			res.send({"error": "wrong_password", "message": "Invalid password."});
			break;
		case this.NO_USERNAME:
			res.statusCode = AUTHENTICATION;
			res.send({"error": "no_username_exists", "message": "Username not found."});
			break;
		case this.EXISTS_USER:
			res.statusCode = METHOD_NOT_ALLOWED;
			res.send({"error": "user_exists", "message": "Username already exists."});
			break;
		case this.NO_MATCHING_USER:
			res.statusCode = METHOD_NOT_ALLOWED;
			res.send({"error": "no_such_user_exists", "message": "User does not exist."});
			break;
		case this.INVALID_AUTHTOKEN:
			res.statusCode = AUTHENTICATION;
			res.send({"error": "invalid_authtoken", "message": "Your session has expired. Please login again."});
			break;
		case this.DB_ERROR:
			res.statusCode = INTERNAL_SERVER;
			if (!dbMessage) {
				dbMessage = "Database error.";
			}
			res.send({"error": "internal_server_error", "message": dbMessage});
			break;
		case this.NO_PUZZLES:
			res.statusCode = METHOD_NOT_ALLOWED;
			res.send({"error": "no_puzzles_to_return", "message": "There arn't any puzzles that you haven't taken in the database right now."});
			break;
		case this.PUZZLE_DOESNT_EXIST:
			res.statusCode = METHOD_NOT_ALLOWED;
			res.send({"error": "puzzle_doesnt_exist", "message": "Sorry. The requested puzzle doesn't appear to exist."});
			break;
		default:
			res.statusCode = INTERNAL_SERVER;
			res.send({"error": "unknown_error", "message": "Unknown error."});
			break;
		}
}

exports.sendError = function sendError(message, res) {
    res.statusCode = (this._500_Errors.indexOf(message) != -1) ? 500 : 400;
    res.send( {error: message} );
};