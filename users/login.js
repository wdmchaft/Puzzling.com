/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/29/12
 * Time: 1:46 PM
 * To change this template use File | Settings | File Templates.
 */

var user = require('./user.js')
  , auth = require('./../authentication');

exports.login = function(req, res) {
    handle_authenticated_request(req, res);
    /*
    auth.verifyRequestAuthtokenAndAPI(req, res, function(verified) {
        if(!verified) {
            res.send({ "error" : "Bad HTTP Method", "statusCode" : 402 });
        }
        else {
            handle_authenticated_request(req, res);
        }
    });*/
}

/*
* Handle authentication based on request method
*/
function handle_authenticated_request(req, res) {
    switch(req.method) {
        // Authentication
        case "GET" :
            handle_login(req.query, res);
            break;

        // Creation
        case "POST" :
            handle_create(req.body, res);
            break;

        // Deletion
        case "DELETE" :
            handle_delete(req.body, res);
            break;

        // Updates
        case "PUT" :
            handle_update(req.body, res);
            break;

        default :
            res.send({ "error" : "Bad HTTP Method", "statusCode" : 402 });
    }
}

/*
 * Success response: { <username>, <authtoken> }
 */
function handle_login(params, res) {
    user.findUserByName(params.username, res, function(foundUser, res) {
        if(foundUser && user.generateHash(params.password, foundUser.salt) == foundUser.password) {
            res.send({"username" : foundUser.username, "authtoken" : foundUser.authToken});
            return;
        }
        res.statusCode = 400;
        res.send({error: "Error, couldn't authenticate"});
    });
}

/*
 * Success response: { <username>, <authtoken>, <userdata> }
 */
function handle_create(params, res) {
    user.handle("create", params, res);
}

/*
 * Success response: { <username>, status: "SUCCESS" }
 */
function handle_delete(params, res) {
    user.handle("delete", params, res);
}

/*
 * Success response: { <username>, status: "SUCCESS" }
 */
function handle_update(params, res) {
    user.handle("update", params, res);
}


