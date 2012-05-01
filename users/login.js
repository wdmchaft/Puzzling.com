/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/29/12
 * Time: 1:46 PM
 * To change this template use File | Settings | File Templates.
 */

var user = require('./user.js')
    , auth = require('./../authentication')
    , err = require("../error.js");

exports.login = function(req, res) {
    _login(req, res);
    /*
    if(req.method != GET && req.method != POST) {
        auth.verifyRequestAuthtokenAndAPI(req, res, function(verified) {
            if(!verified) {
                res.send({ "error" : "Bad HTTP Method", "statusCode" : 402 });
            }
            else {
                _login(req, res);
            }
        });
    }
    else {
        // If GET request, don't worry about checking params
        _login(req, res);
    }
    */
}

// HTTP verbs correspond to different actions

function _login(req, res) {
    switch(req.method) {
        // Authentication
        case "GET" :
            _verify(req.query, res);
            break;

        // Creation
        case "POST" :
            _create(req.body, res);
            break;

        // Deletion
        case "DELETE" :
            _delete(req.body, res);
            break;

        // Updates
        case "PUT" :
            _update(req.body, res);
            break;

        default :
            res.send({ "error" : "Bad HTTP Method", "statusCode" : 402 });
    }
}

/*
 * Success response: { <username>, <authtoken> }
 */
function _verify(params, res) {
    console.log("Trying to verify { user %s , password %s }", params.username, params.password);

    user.findUserByName(params.username, res, function(foundUser, res) {
        if(foundUser && user.generateHash(params.password, foundUser.salt) == foundUser.password) {
            // only give back auth token and
            // username; in the future, we may
            // want to give back the whole username
            res.send({"username" : foundUser.username, "authToken" : foundUser.authToken});
        } else {
            err.send_error(err.NO_MATCHING_USER, res);
        }
    });
}

/*
 * Success response: { <username>, <authtoken>, <userdata> }
 */
function _create(params, res) {
    user.handle("create", params, res);
}

/*
 * Success response: { <username>, status: "SUCCESS" }
 */
function _delete(params, res) {
    user.handle("delete", params, res);
}

/*
 * Success response: { <username>, status: "SUCCESS" }
 */
function _update(params, res) {
    user.handle("update", params, res);
}


