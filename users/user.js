/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */


/* User Authentication is handled by checking an */

var db = require('./../db')
  , hash = require('./../hash')
  , mongoose = require('mongoose')
  , User = db.UserModel;


// When a user is first being created
var DEFAULTS = {
    DEFAULT_RATING      : 1500,
    DEFAULT_DEVIATION   : 150
}

// Map of possible user operations
// to callback functions

var OPS = {
    "create"  : createCallback,
    "delete"  : deleteCallback,
    "update"  : updateCallback
}

/***** Handles incoming GET requests *****/

exports.info = function(req, res) {
    if(!req.params.username) {
        res.send(msg.MISSING_INFO);
        return;
    }

    findUserByName(req.params.username, res, function(found, res) {
        if(!found) {
            res.send(msg.NOT_FOUND);
        }
        else {
            res.send(JSON.stringify(found));
        }
    });

}

/***** List all users - DEBUGGING *****/

exports.list = function(req, res){
    var resultSet = [];
    User.find({}, function(err, docs) {
        if(!err) {
            docs.forEach(function(doc) {
                resultSet.push(JSON.stringify(doc));
            });
        }
        res.send(JSON.stringify(resultSet));
    });
};

/***** Handles incoming POST requests *****/

exports.handle = function(op, params, res){

    if(!OPS.hasOwnProperty(op)) {
        send_error(msg.BAD_OP, res);
        return;
    }

    // save copy to be accessed by callbacks
    res.reqBody = params;

    // call the function callback
    this.findUserByName(params.username, res, OPS[op]);
};

/******* Rendered Views *********/

exports.view = function(req, res){
    res.render('users/view', {
        title: 'Viewing user ' + req.user
        , user: req.user
    });
};

/******** Error Handling *********/

var msg = {NO_PASSWORD: "no_password_exists", NO_USER: "no_username_exists", EXISTS_USER: "user_exists",
    NO_MATCHING_USER: "no_such_user_exists", BAD_OP: "no_such_operation", NOT_FOUND: "not_found",
    UPDATE_ERROR: "error_updating", NOT_AUTHENTICATED: "not_authenticated"}

function send_error(message, res) {
    res.statusCode = 400;
    res.send( {error: message } );
}

/******** Helper functions ******/

// sha1 hash
function generateHash(input, salt) {
    return hash.sha1(input, salt);
}
exports.generateHash = generateHash;

// md5 hash using (presumably) name + password
function generateToken(first, second) {
   return generateHash(first + second);
}

/*
 * FIND USER
 *
 * finds and returns execution back to
 * fnCallback when done. We want to have the
 * res parameter visible to back to the callback.
 */
exports.findUserByName = function findUserByName(name, res, fnCallback) {
    var query = {'username': name };
    User.findOne(query, function(err, foundUser) {
        if(!err) {
            fnCallback(foundUser, res);
        } else {
            res.statusCode = 500;
            res.send({error: "Oops, something bad happened on our end. We're trying to fix it asap!"});
        }
    });
}

/*
* USER CREATION
*
* if mongoose find the user, report an error
* message. Otherwise, try to create and save the
* user info. If successful, returns a dict of
* {<username>, <authtoken>}
*/
function createCallback(found, res) {
    if(found) {
        console.log("[CREATE] : User " + found.username + " exists; stopping creation");
        send_error(msg.EXISTS_USER, res);
        return;
    }
    var params = res.reqBody;
    var salt = "abcd" + Math.floor(Math.random() * 100000);
    var specs = {
                    username   : params.username
                  , password   : generateHash(params.password, salt)
                  , salt       : salt
                  , authToken  : generateToken(params.username, params.password)
                  , rating     : DEFAULTS.DEFAULT_RATING
                  , rd         : DEFAULTS.DEFAULT_DEVIATION
                  , user_data  : params.user_data
    }
    var newUser = new User(specs);
    newUser.save(function(err) {
        if(err) {
            send_error(err, res);
        }
    });

    console.log("[CREATE] : Created user " + newUser.username)
    res.send({"username" : newUser.username, "authtoken" : newUser.authToken });
}

/*
* DELETE USER
*
* if mongoose finds, delete user and report
* a "successful" status message.
*/
function deleteCallback(found, res) {
    if(!found) {
        send_error(msg.NO_USER, res);
        return;
    }
    if(found.authToken != res.reqBody["authtoken"]) {
        send_error(msg.NOT_AUTHENTICATED, res);
        return;
    }
    var name = found.username;
    console.log("[DELETE] : Deleting user " + name);
    found.remove();
    res.send({"username" : name, "status":"SUCCESS"});
}

/*
* UPDATE USER
*
* Treats the request body as an update statement
* and, as long as the auth token is good, updates
* the user info
*
*/
function updateCallback(found, res) {
    if(!found) {
        res.send({error: msg.NO_USER, statusCode:400});
        console.log("[UPDATE] : Tried to update user info for username '" + res.reqBody.username + "' but user not found");
        return;
    }
    // saved copy of req data
    var params = res.reqBody;

    // hash password b4 continuing
    // we should probably change the salt too...
    if(params.password)
        params.password = generateHash(params.password, found.salt);

    // verify tokens
    if(params["authtoken"] != found.authToken) {
        res.send({error:msg.NOT_AUTHENTICATED, statusCode:400});
        return;
    }

    var name = params.username;
    // delete params that shouldn't be set
    delete params.authtoken;
    delete params.username;

    // make sure our parameters are
    var conditions = {username : name},
        update = params;

    User.update(conditions, update, {}, function(err, numAffected) {
        console.log("[UPDATE] : Numaffected: " + numAffected)
        if(!err && numAffected > 0) {
            res.send({"username" : name, "status":"SUCCESS"});
        }
        else {
            res.send({error: msg.UPDATE_ERROR, statusCode:400});
        }
    });
}