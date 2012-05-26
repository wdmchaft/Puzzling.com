/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 5/21/12
 * Time: 5:02 PM
 * Simple descending leaderboard filters.
 *
 * TODO:
 *  Test get and filter
 *  Anyway to do sorting faster ?
 *      (Probably not, this is pretty straightforward)
 */

var db = require('./db')
    , _e = require('./error.js')
    , _u = require('./utils.js');

var pApp = db.pAppModel
    , User = db.UserModel;

exports.get = function (req, res) {
    User.find({}).sort("rating", -1).limit(20).execFind(function(err, users) {
        if(!err) { 
        	Array.prototype.forEach.call(users, function(el) {
        		delete el.authToken;
        	});
        	res.send(JSON.stringify(users));
        } else _e.send_error(_e.DB_ERROR, res);
    });
};


//
// Filter by a certain puzzle field
//

var FILTERS = ["rating", "likes", "dislikes", "rd"];

exports.filter = function (req, res) {
    var filter = req.params.filter
        , puzzleId = req.params.id
        , apiKey = _u.stripNonAlphaNum(req.apiKey)
        , TargetModel = pApp.findPuzzleModel(apiKey);

    if(FILTERS.indexOf(filter) != -1) {
        TargetModel.find().sort(filter, -1).execFind(function(err, puzzles) {
            if(!err) {
	            res.send(JSON.stringify(puzzles));
            } else _e.send_error(_e.DB_ERROR, res);
        });
    } else _e.send_error(_e.BAD_OPERATION, res);
};
