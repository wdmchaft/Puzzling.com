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
    , user = require('./user')
    , auth = require('./authentication.js')
    , mongoose = require('mongoose')

    , Friend = db.FriendRequestModel;

/**** Error Handling *****/

var msg = user.msg + {
    FRIENDSHIP_EXISTS : "friendship_exists",
    MISSING_INFO      : "missing_information_in_query",
}

exports.list = function(req, res){
    var resultSet = [];
    Friend.find({}, function(err, docs) {
        if(!err && docs != null) {
            resultSet = docs;
        }
    })
    res.render('users', { title: 'Friendships', friends: resultSet });
};

exports.request = function(req, res) {
    // @auth
    if(!user.isAuthenticated(req, res)) {
        return;
    }
    if(!(req.params.to && req.params.from)) {
        send_error(msg.MISSING_INFO, res);
        return;
    }

    var toUser = undefined,
        fromUser = undefined;

    user.findUserByName(req.params.to, res, function(found, res) {
        toUser = found;
        handleFriendCallback(toUser, fromUser, res);
    });
    user.findUserByName(req.params.from, res, function(found, res) {
        fromUser = found;
        handleFriendCallback(toUser, fromUser, res);
    });
}

/* send the http response here
*
* NOTE: Only reason we can call res.send
* in two places here is that we know the conditions
* are mutually exclusive and that the two callbacks
* will not execute simultaneously
*/
function handleFriendCallback(toUser, fromUser, res) {
    if(!(toUser && fromUser && res)) return;

    // 1. look to insert a new Friendship object
    Friend.findOne({to : toUser.id, from : fromUser.id}, function(err, rel) {
        if(!err && rel.toString() != 'not_found') {
            processFriendship(true, false, null, toUser, fromUser);
            res.send("Notifying user " + toUser.name + " of friend request");
        }
    });

    // 2. look to find the symmetric relationship and
    // permaenntly make the two sides friends
    Friend.findOne({to : fromUser.id, from : toUser.id}, function(err, rel) {
        if(!err) {
            processFriendship(false, true, rel);
            res.send("Confirming friendship");
        }
    });
}

function processFriendship(found, matching, matchingRelation, toUser, fromUser) {

    if(!found && toUser && fromUser) {
        // save this relationship, and
        // place a request to appropriate user
        var specs = {to:toUser.id, from:fromUser.id};
        var friendRequest = new Friend(specs);
        friendRequest.save();
        toUser.friendRequests.push(friendRequest.id);
    }

    if(matching && matchingRelation) {
        // take out the old, and
        // confirm friendships
        matchingRelation.remove();
        toUser.friends.push(fromUser.id);
        fromUser.friends.push(toUser.id);
    }
}



