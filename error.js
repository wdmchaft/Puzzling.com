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

exports.NO_PASSWORD = "no_password_exists";
exports.NO_USER = "no_username_exists";
exports.EXISTS_USER = "user_exists";
exports.NO_MATCHING_USER = "no_such_user_exists";
exports.BAD_OP = "no_such_operation";
exports.NOT_FOUND = "not_found";
exports.UPDATE_ERROR = "error_updating";
exports.NOT_AUTHENTICATED = "not_authenticated";
exports.MISSING_INFO = "missing_parameters";

/*
 * Sends JSON formatted error code back to the user.
 * Message can be any of the above, or a custom string.
 */
exports.send_error = function send_error(message, res) {
    res.statusCode = 400;
    res.send( {error: message } );
}