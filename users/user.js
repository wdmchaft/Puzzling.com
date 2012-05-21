/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 *
 * User Module controller
 */

/**
 * Module dependencies.
 */

var db = require('./../db')
    , hash = require('./../hash')
    , err = require('./../error.js');

var User = db.UserModel;

// When a user is first being created

var DEFAULTS = {
    DEFAULT_RATING      : 1500,
    DEFAULT_DEVIATION   : 150
};

// Exports at top

exports.handle = handle;
exports.view = view;
exports.list = list;
exports.get = get;
exports.generateHash = generateHash;
exports.findUserByName = findUserByName;
exports.getData = getData;
exports.postData = postData;

// Handle GET

function get(req, res) {
    findUserByName(req.params.username, res, function(found, res) {
        if(!found) err.sendError(err.notFound, res);
        else res.send(JSON.stringify(found));
    });
}

// Rendered Views
function view(req, res){
    res.render('users/view', {
        title: 'Viewing user ' + req.user
        , user: req.user
    });
}

// List all users
function list(req, res){
    User.find({}, function(e, docs) {
        if(!e) {
            res.send(JSON.stringify(docs));
        } else {
            res.send("");
        }
    });
}

/////////////////////////////
// Handle CRUD actions
/////////////////////////////

// Map of possible user operations
// to callback functions.

var CRUD = {
    "create"  : createCB,
    // 'read' doesn't require a callback
    "update"  : updateCB,
    "delete"  : deleteCB
};

function handle(action, params, res){
    if(CRUD.hasOwnProperty(action)) {
        console.log("[user] : Handling " + action + " request");
        // save copy to be accessed by callbacks
        res.reqBody = params;
        // call the function callback
        this.findUserByName(params.username, res, CRUD[action]);
    } else {
        err.sendError(err.badOperation, res);
    }
}

//
// FIND USER
//
// finds and returns execution back to
// fnCallback when done. We want to have the
// res parameter visible to back to the callback.
 //
function findUserByName(name, res, fnCallback) {
    var query = {'username': name };
    User.findOne(query, function(e, found) {
        if(!e) {
            fnCallback(found, res);
        } else err.sendError(err.transactionError, res);
    });
}

// md5 hash using (presumably) name + password
function generateToken(first, second) {
   return generateHash(first + second);
}

// sha1 hash
function generateHash(input, salt) {
    return hash.sha1(input, salt);
}

//
// USER CREATION
//
// if mongoose finds the user, report an error
// message. Otherwise, try to create and save the
// user info. If successful, returns a dict of
// {<username>, <authToken>}
//
function createCB(existingUser, res) {
    console.log('[create] trying to create user ' + res.reqBody["username"]);
    if(!existingUser) {
        var params = res.reqBody;
        if(!(params.hasOwnProperty("username") &&
            params.hasOwnProperty("password"))) {
            err.sendError(err.missingInfo, res);
            return;
        }

        // saves the user with a fresh salt and password.
        // Newly created users start with a baseline rating and
        // an auto-created authToken, which is at the moment a SHA-1 hash

        var specs = {username   : params.username
                   , authToken  : generateToken(params.username, params.password)
                   , rating     : DEFAULTS.DEFAULT_RATING
                   , rd         : DEFAULTS.DEFAULT_DEVIATION
                   , user_data  : params.user_data || "{}"
            };
        var newUser = new User(specs);

        newUser.set_password(params["password"]);
        newUser.save(function(e) {
            if(!e) console.log("[CREATE] : Created user " + newUser.username);
        });
        res.send(JSON.stringify({user_id : newUser._id
                                , username : newUser.username
                                , authToken : newUser.authToken }));
    } else {

        // user already exists;
        // send notification and quit

        console.log("[CREATE] : User " + existingUser.username + " exists; stopping creation");
        err.sendError(err.existsUser, res);
    }
}

// DELETE USER
//
// if mongoose finds, delete user and report
// a "successful" status message.
// We want to check here for auth token because
// only a user should be able to delete him / herself
//
function deleteCB(found, res) {
    if(found) {
        var name = found.username;
        console.log("[DELETE] : Deleting user " + name);
        found.remove();
        res.send({"username" : name, "success":true});
    } else {
        err.sendError(err.noMatchingUser, res);
    }
}

//
// UPDATE USER
//
// Treats the request body as an update statement
// and, as long as the auth token is good, updates
// the user info
//

function updateCB(found, res) {
    if(!found) {
        err.sendError(err.noUser, res);
        console.log("[UPDATE] : Tried to update user info for username '" + res.reqBody.username + "' but user not found");
        return;
    }

    // saved copy of req data
    var params = res.reqBody;
    if(!(params.hasOwnProperty("username"))) {
        err.sendError(err.missingInfo, res);
        return;
    }

    // hash password in-place so we don't have to
    // compute afterwards. Should change the salt too...
    if(params.hasOwnProperty("password")) {
        params.password = generateHash(params.password, found.salt);
    }

    // authToken in body should match
    // target user's token
    if(params["authToken"] != found.authToken) {
        res.send({error:err.notAuthenticated, statusCode:400});
        return;
    }

    var name = params.username;
    // delete params that shouldn't be set
    // ordering is important as we delete
    // the naming parameter after this line.
    delete params.authToken;
    delete params.username;

    var conditions = {username : name};

    User.update(conditions, params, {}, function(e, numAffected) {
        console.log("[UPDATE] : Num affected: " + numAffected);
        if(!e && numAffected > 0) {
            res.send({"username" : name, "success":true});
        }
        else {
            res.send({error: err.updateError, statusCode:400});
        }
    });
}

///////////////////
// User Data only
///////////////////

//
// gets user data
//
function getData(req, res) {
    // API rules specify username should
    // be part of url, authToken a GET
    // parameter
    var targetName = req.params["name"]
        , targetToken = req.query["authToken"];

    findUserByName(targetName, res, function(foundUser, res) {
        if(foundUser && foundUser.authToken === targetToken) {
            res.send(JSON.stringify(foundUser.user_data));
        } else err.sendError(err.notFound, res);
    });
}

//
//  posts user data
//
function postData(req,res) {
    // API rules specify username should
    // be part of url, authToken a GET
    // parameter
    var targetName = req.params["name"]
        , targetToken = req.body["authToken"]
        , userData = req.body["user_data"];

    var conditions = {"username": targetName}
        , updates = userData;

    db.UserModel.update(conditions, updates, {}, function(e, numAffected) {
        if(!e && numAffected > 0) res.send({"success": true});
        else {
            if(e) console.log(e);
            err.sendError(err.transactionError, res);
        }
    });
}

