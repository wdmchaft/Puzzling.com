/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */


/* User Authentication is handled by checking an */

var db = require('./db')
  , hash = require('./hash')
  , auth = require('./authentication.js')
  , mongoose = require('mongoose')

  , User = db.UserModel;

/**** Error Handling *****/

var msg = {
    NO_PASSWORD         : "no_password_exists",
    NO_USER             : "no_username_exists",
    EXISTS_USER         : "user_exists",
    NO_MATCHING_USER    : "no_such_user_exists",
    BAD_OP              : "no_such_operation",
    NOT_FOUND           : "not_found",
    UPDATE_ERROR        : "error_updating",
    NOT_AUTHENTICATED   : "not_authenticated"
}

function send_error(msg, res) {
    res.statusCode = 400;
    res.send( {error: msg } );
}

/**** User Module *****/

/*
 * Edits information about the user depending
 * on the field.
 * @auth token required
 */

// When a user is first being created
var DEFAULTS = {
    DEFAULT_RATING      : 1500,
    DEFAULT_DEVIATION   : 0
}

// Map of possible user operations
// to callback functions

var OPS = {
    "create"  : createCallback,
    "delete"  : deleteCallback,
    "change"  : changeCallback
}

// sha1 hash
function generateHash(input, salt) {
    return hash.sha1(input, salt);
}

// md5 hash using (presumably) name + password
function generateToken(first, second) {
   return generateHash(first + second);
}

// finds and returns execution back to
// fnCallback when done
function findUserByName(name, res, fnCallback) {
    var query = {'name': name };
    User.findOne(query, function(err, foundUser) {
        if(!err) {
            fnCallback(foundUser, res);
        }
    });
}
exports.findUserByName = findUserByName;

function isAuthenticated(req, res, exitCallback) {
    auth.verifyRequestAuthtokenAndAPI(req, res, function(success) {
        return success;
    });
}
exports.isAuthenticated = isAuthenticated;

/***** List all users - DEBUGGING *****/

exports.list = function(req, res){
    var resultSet = [];
    User.find({}, function(err, docs) {
        if(!err) {
            docs.forEach(function(doc) {
                resultSet.push(JSON.stringify(doc));
            });
        }
        res.send(resultSet.toString());
    });
};

/***** Handles incoming POST requests *****/

exports.handle = function(req, res, next){
/*
    // @auth
    if(!isAuthenticated(req, res)) {
        return;
    }
*/
    // handle POST only
    var params = req.body;
    var op = req.params.op;

    if(!(op && params && OPS.hasOwnProperty(op))) {
        send_error(msg.BAD_OP, res);
        return;
    }

    // save copy to be accessed by callbacks
    res.reqBody = params;

    // call the function callback
    findUserByName(params.name, res, OPS[op]);
};

/* if mongoose finds, create callback */
function createCallback(found, res) {
    if(found) {
        send_error(msg.EXISTS_USER, res);
        return;
    }

    var params = res.reqBody;

    var salt = "abcd" + Math.floor(Math.random() * 100000);
    var specs = {
                    name       : params.name
                  , password   : generateHash(params.password, salt)
                  , salt       : salt
                  , authToken  : generateToken(params.name, params.password)
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

    res.send(JSON.stringify(newUser));
}

/* if mongoose finds, delete it */
function deleteCallback(found, res) {
    if(!found) {
        send_error(msg.NO_USER, res);
        return;
    }
    found.remove();
    res.send("Successfully deleted user");
}

/* if mongoose finds, change and post a response */
function changeCallback(found, res) {
    if(!found) {
        send_error(msg.NO_USER, res);
        return;
    }

    // saved copy of req data
    var params = res.reqBody;

    // hash password b4 continuing
    if(params.password)
        params.password = generateHash(params.password, found.salt);

    // don't allow changing of tokens
    delete params.authToken;

    // params.data is JSON object rep. of
    // user data taken from retrieving
    // user information
    var conditions = {name : params.name},
        update = params;

    User.update(conditions, update, {}, function(err, numAffected) {
        if(!err) {
            res.send("Ok. " + numAffected + " docs changed.");
        }
        else {
            send_error(msg, msg.UPDATE_ERROR);
        }
    });
}

/***** Handles incoming GET requests *****/

exports.info = function(req, res) {
/*
    // @auth
    if(!isAuthenticated(req, res)) {
        return;
    }
*/
    if(!req.params.name) {
        res.send(msg.MISSING_INFO);
        return;
    }

    findUserByName(req.params.name, res, function(found, res) {
        if(!found) {
            res.send(msg.NOT_FOUND);
        }
        else {
            res.send(JSON.stringify(found));
        }
    });

}

/***** Rendered Views *****/

exports.view = function(req, res){
    res.render('users/view', {
        title: 'Viewing user ' + req.user
        , user: req.user
    });
};

