/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 *
 * User Module controller
 */

var db = require('./../db')
    , hash = require('./../hash')
    , mongoose = require('mongoose')
    , err = require('./../error.js')
    , User = db.UserModel;

// When a user is first being created

var DEFAULTS = {
    DEFAULT_RATING      : 1500,
    DEFAULT_DEVIATION   : 150
}

// Map of possible user operations
// to callback functions.

var OPS = {
    "create"  : createCallback,
    "delete"  : deleteCallback,
    "update"  : updateCallback
}

// Exports at top
exports.info = info
    , exports.handle = handle
    , exports.view = view
    , exports.list = list
    , exports.generateHash = generateHash
    , exports.findUserByName = findUserByName;

/* ----------- Handles GET ----------- */

function info(req, res) {
    findUserByName(req.params.username, res, function(found, res) {
        if(!found) {
            err.send_error(err.NOT_FOUND, res);
        }
        else {
            res.send(JSON.stringify(found));
        }
    });

}

/* ----------- Handle POST/PUT/DELETE ----------- */

function handle(op, params, res){
    if(OPS.hasOwnProperty(op)) {
        // save copy to be accessed by callbacks
        res.reqBody = params;

        // call the function callback
        this.findUserByName(params.username, res, OPS[op]);
    } else {
        err.send_error(err.BAD_OP, res);
    }
};

/* ----------- Rendered Views ----------- */

function view(req, res){
    res.render('users/view', {
        title: 'Viewing user ' + req.user
        , user: req.user
    });
};

// List all users
function list(req, res){
    User.find({}, function(e, docs) {
        if(!e) {
            res.send(JSON.stringify(resultSet));
        } else {
            res.send("");
        }
    });
};

/* ----------- Find user feature ----------- */

/*
 * FIND USER
 *
 * finds and returns execution back to
 * fnCallback when done. We want to have the
 * res parameter visible to back to the callback.
 */
function findUserByName(name, res, fnCallback) {
    var query = {'username': name };
    User.findOne(query, function(e, foundUser) {
        if(!e) {
            fnCallback(foundUser, res);
        } else {
            res.statusCode = 500;
            res.send({error: "Oops, something bad happened on our end. We're trying to fix it asap!"});
        }
    });
}

/* ----------- Helper functions ----------- */

// md5 hash using (presumably) name + password
function generateToken(first, second) {
   return generateHash(first + second);
}

// sha1 hash
function generateHash(input, salt) {
    return hash.sha1(input, salt);
}

/* ------------ Callbacks ------------ */

/*
* USER CREATION
*
* if mongoose finds the user, report an error
* message. Otherwise, try to create and save the
* user info. If successful, returns a dict of
* {<username>, <authtoken>}
*/
function createCallback(existingUser, res) {
    if(!existingUser) {
        var params = res.reqBody;
        if(!(params.hasOwnProperty("username") &&
            params.hasOwnProperty("password"))) {
            err.send_error(err.MISSING_INFO, res);
            return;
        }

        // saves the user with a fresh salt and password.
        // Newly created users start with a baseline rating and
        // an auto-creatd authToken, which is at the moment a SHA-1 hash

        var salt = "abcd" + Math.floor(Math.random() * 100000);
        var specs = {username   : params.username
                      , password   : generateHash(params.password, salt)
                      , salt       : salt
                      , authToken  : generateToken(params.username, params.password)
                      , rating     : DEFAULTS.DEFAULT_RATING
                      , rd         : DEFAULTS.DEFAULT_DEVIATION
                      , user_data  : params.user_data || "{}"
        }
        var newUser = new User(specs);
        newUser.save(function(e) {
            if(!e) console.log("[CREATE] : Created user " + newUser.username);
        });
        res.send({"username" : newUser.username, "authtoken" : newUser.authToken });
    } else {
        console.log("[CREATE] : User " + existingUser.username + " exists; stopping creation");
        err.send_error(err.EXISTS_USER, res);
    }

}

/*
* DELETE USER
*
* if mongoose finds, delete user and report
* a "successful" status message.
*/
function deleteCallback(found, res) {
    if(found) {
        var name = found.username || undefined;
        console.log("[DELETE] : Deleting user " + name);
        found.remove();
        res.send({"username" : name, "status":"SUCCESS"});
    } else {
        err.send_error(err.NO_USER, res);
    }
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
        err.send_error(err.NO_USER, res);
        console.log("[UPDATE] : Tried to update user info for username '" + res.reqBody.username + "' but user not found");
        return;
    }

    // saved copy of req data
    var params = res.reqBody;
    if(!(params.hasOwnProperty("username"))) {
        err.send_error(err.MISSING_INFO, res);
        return;
    }

    // hash password in-place so we don't have to
    // compute afterwards. Should change the salt too...
    if(params.password)
        params.password = generateHash(params.password, found.salt);

    if(params["authtoken"] != found.authToken) {
        res.send({error:err.NOT_AUTHENTICATED, statusCode:400});
        return;
    }

    var name = params.username;
    // delete params that shouldn't be set
    delete params.authtoken;
    delete params.username;

    var conditions = {username : name},
        update = params;

    User.update(conditions, update, {}, function(e, numAffected) {
        console.log("[UPDATE] : Numaffected: " + numAffected)
        if(!e && numAffected > 0) {
            res.send({"username" : name, "status":"SUCCESS"});
        }
        else {
            res.send({error: err.UPDATE_ERROR, statusCode:400});
        }
    });
}