/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 5/21/12
 * Time: 5:00 PM
 */


var db = require('./db')
    , _e = require('./error.js')
    , _u = require('./utils.js');

var pApp = db.pAppModel
    , Comment = db.CommentModel;

exports.get = function get(req, res) {
    var puzzleId = _u.stripNonAlphaNum(req.params["id"]);

    Comment.find({puzzle: puzzleId}, function(err, docs) {
        if(err)
            _e.send_error(err, res);
        else {
            // success
            res.send(JSON.stringify(docs));
        }
    });
};

exports.post = function post(req, res) {
    var apiKey = _u.stripNonAlphaNum(req.apiKey)
        , TargetModel = pApp.findPuzzleModel(apiKey)
        , puzzleId = _u.stripNonAlphaNum(req.params["id"])
        , comment = req.body["comment"];
		
		if (comment == undefined)
		{
			_e.send_error(_e.MISSING_INFO, res);
			return;
		}

    TargetModel.findById(puzzleId, function(e, puzzle) {
        if (e) {
            console.log("[comment] " + e);
            _e.send_error(_e.DB_ERROR, res);
        }
        else if (!puzzle) {
            console.log("[comment] didn't find puzzle with apikey" + puzzleId);
            _e.send_error(_e.PUZZLE_DOESNT_EXIST, res);
        }
        else {
           // success; create new comment
            var specs = {
                user: req.user.id
                , username: req.user.username
                , puzzle: puzzleId
                , value: comment
                , timestamp: Date.now()
            };
            var newC = new Comment(specs);
            newC.save(function(err) {
                if(err) _e.send_error(err, res);
                else res.send({success:true});
            });
        }
    });
};





