/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/29/12
 * Time: 1:46 PM
 * To change this template use File | Settings | File Templates.
 */

var userModule = require('./user.js')
    , err = require("../error.js");

//
// Filter Middleware to prevent redundancy.
// Special because we're filtering based on
// the request type, so we can't use a generic
// type of filtering
//
exports.get = read;
exports.post = create;
exports.put = update;
exports.delete = _delete; // delete is a js keyword

//
// Success response: { <username>, <authtoken> }
//
function read(req, res) {
    var params = req.query;

    console.log(params);
    console.log("[login] Trying to verify { user %s , password %s }", params.username, params.password);

    userModule.findUserByName(params.username, res, function(foundUser, res) {
        if(foundUser && userModule.generateHash(params.password, foundUser.salt) == foundUser.password) {
            // only give back auth token and
            // username; in the future, we may
            // want to give back the whole username
            var info = {'username' : foundUser.username, 'authToken' : foundUser.authToken };
            res.send(JSON.stringify(info));
        } else {
            err.sendError(err.noMatchingUser, res);
        }
    });
}

//
// Success response: { <username>, <authtoken>, <userdata> }
//
function create(req, res) {
    userModule.handle("create", req.body, res);
}

//
// Success response: { <username>, "success":true }
//
function _delete(req, res) {
    userModule.handle("delete", req.body, res);
}

//
// Success response: { <username>, "success":true }
//
function update(req, res) {
    userModule.handle("update", req.body, res);
}


