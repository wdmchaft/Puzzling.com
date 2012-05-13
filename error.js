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

exports._500_Errors = [this.transactionError];

/*
 * Sends JSON formatted error code back to the user.
 * Message can be any of the above, or a custom string.
 */
exports.sendError = function sendError(message, res) {
    res.statusCode = (this._500_Errors.indexOf(message) != -1) ? 500 : 400;
    res.send( {error: message} );
}