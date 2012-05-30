/**
* Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

var db = require('./db')
, err = require('./error.js')
, glicko = require('./glicko')
, _u = require('./utils.js')
, url = require('url');


var pApp = db.pAppModel
, UserModel = db.UserModel;

///////////////////////
//		create 		//
/////////////////////

exports.create = function(req, res) {
	var apiKey = _u.stripNonAlphaNum(req.apiKey);
	// one-to-one mapping between apiKey and app
	pApp.findOne({apiKey : apiKey}, function(e, doc) {
		if(!e && doc) {
			createPuzzle(req, res, doc);
		}
		else if (!doc) err.send_error(err.API_KEY, res);
		else err.send_error(err.DB_ERROR, res);
	});
};

// actually creates the puzzle
function createPuzzle(req, res, papp) {
	var setupData = req.body.setupData;
	var solutionData = req.body.solutionData;
	// var additionalData = req.body.additionalData;
	var puzzleType = req.body["puzzleType"] || req.body["type"];
	var puzzleName = req.body["puzzleName"];
	
	var specs = {
            name            : puzzleName
		,   setupData       : JSON.stringify(setupData)
		,   solutionData    : JSON.stringify(solutionData)
		,   type            : puzzleType
		,   likes           : 0
		,   dislikes        : 0
		,   taken           : 0
		,   timestamp       : new Date()
		,   rating          : 1500
		,   rd              : 250
		,   creator         : req.user._id
		,		flaggedForRemoval	: false
		,		removed					: false
	};
	
	// creates a puzzling application based on
	// the specs; implicitly creates a new mongo
	// collection as well behind the scenes.
	var puzzleInstance = papp.createPuzzle(specs);
	
	puzzleInstance.save(function(err) {
		if (err) {
			err.send_error(err.DB_ERROR, res);
		} else {
			var returnData = req.body;
			returnData["_id"] = puzzleInstance._id;
			returnData["creator"] = puzzleInstance.creator;
			returnData["likes"] = puzzleInstance.likes;
			returnData["rating"] = puzzleInstance.rating;
			returnData["dislikes"] = puzzleInstance.dislikes;
			returnData["timestamp"] = puzzleInstance.timestamp;
			returnData["success"] = true;
			res.send(JSON.stringify(returnData));
		}
	});
}

///////////////////////
//		Read		//
/////////////////////

exports.get = function(req, res) {
	
	var puzzleID = _u.stripNonAlphaNum(req.params.id);
	
	// standard retrieval procedure to follow
	// when querying for a specific puzzle
	// given an apiKey.
	
	var TargetModel = pApp.findPuzzleModel(_u.stripNonAlphaNum(req.apiKey));
	TargetModel.findById(puzzleID, function(e, puzzleInstance) {
		if(e) err.send_error(err.DB_ERROR, res);
		else if(!puzzleInstance) err.send_error(err.PUZZLE_DOESNT_EXIST, res);
		else {
			res.send(JSON.stringify(puzzleInstance));
		}
	});
};

//////////////////////////
//		Delete			//
//////////////////////////

exports.delete = function(req, res) {
	var puzzleId = _u.stripNonAlphaNum(req.body.puzzle_id);
	if(puzzleId) {
		// standard retrieval procedure to follow
		// when querying for a specific puzzle
		// given an apiKey.
		var apiKey = _u.stripNonAlphaNum(req.apiKey);
		var TargetModel = pApp.findPuzzleModel(apiKey);
		console.log("[puzzle] trying to delete puzzle w/ id " + puzzleId);
		TargetModel.findById(puzzleId, function(e, puzzle) {
			if(e) err.send_error(err.DB_ERROR, res);
			else if(!puzzle) err.send_error(err.PUZZLE_DOESNT_EXIST, res);
			else {
				puzzle.removed = true;
				puzzle.save(function(e) {
					if (e)
					{
						err.send_error(err.DB_ERROR, res);
					}
					else
					{
						console.log("[puzzle] successfully deleted puzzle w/ id " + puzzleId);
						res.send({puzzle_id : puzzleId, success : true});
					}
				});
			}
		});
	} else err.send_error(err.MISSING_INFO, res);
};

exports.getFlaggedPuzzles = function(req, res)
{
	var apiKey = _u.stripNonAlphaNum(req.apiKey);
	var TargetModel = pApp.findPuzzleModel(apiKey);
	console.log("[puzzle] trying to find flagged puzzles");
	
	TargetModel
				.where('removed', false)
				.where('flaggedForRemoval', true)
				.run(function(e, docs) {
					if(e) err.send_error(err.DB_ERROR, res);
					else
					{
						for (var i = 0; i<docs.length; i++) {
							docs[i].setupData = undefined;
							docs[i].solutionData = undefined;
						}
						console.log("[puzzle] successfully found flagged puzzles");
						res.send(docs);
					}
	});
}

exports.flagForRemoval = function(req, res)
{
	var puzzle_id = req.params.id;
	if (puzzle_id)
	{
		var apiKey = _u.stripNonAlphaNum(req.apiKey);
		var TargetModel = pApp.findPuzzleModel(apiKey);
		console.log("[puzzle] trying to flag puzzle for removal w/ id " + puzzle_id);
		TargetModel.findById(puzzle_id, function(e, puzzle) {
			if(e) err.send_error(err.DB_ERROR, res);
			else if(!puzzle) err.send_error(err.PUZZLE_DOESNT_EXIST, res);
			else
			{
				puzzle.flaggedForRemoval = true;
				puzzle.save(function(e) {
					if (e)
					{
						err.send_error(err.DB_ERROR, res);
					}
					else
					{
						console.log("[puzzle] successfully flagged puzzle w/ id " + puzzle_id);
						res.send({puzzle_id : puzzle_id, success : true});
					}
				});
			}
		});
	}
	else
	{
		err.send_error(err.MISSING_INFO, res);
	}
}

exports.removeFlag = function(req, res)
{
	var puzzle_id = req.params.id;
	if (puzzle_id)
	{
		var apiKey = _u.stripNonAlphaNum(req.apiKey);
		var TargetModel = pApp.findPuzzleModel(apiKey);
		console.log("[puzzle] trying to deflag puzzle for removal w/ id " + puzzle_id);
		TargetModel.findById(puzzle_id, function(e, puzzle) {
			if(e) err.send_error(err.DB_ERROR, res);
			else if(!puzzle) err.send_error(err.PUZZLE_DOESNT_EXIST, res);
			else
			{
				puzzle.flaggedForRemoval = false;
				puzzle.save(function(e) {
					if (e)
					{
						err.send_error(err.DB_ERROR, res);
					}
					else
					{
						console.log("[puzzle] successfully deflagged puzzle w/ id " + puzzle_id);
						res.send({puzzle_id : puzzle_id, success : true});
					}
				});
			}
		});
	}
	else
	{
		err.send_error(err.MISSING_INFO, res);
	}
}

//
// updates assume that the user will have
// all fields they want updated fully specified
//
///////////////////////////
// 		Update			//
/////////////////////////

exports.update = function(req, res) {
	var data = {}
	, body = req.body
	, puzzleId = _u.stripNonAlphaNum(req.body.puzzle_id)
	, apiKey = _u.stripNonAlphaNum(req.apiKey);
	
	if(puzzleId) {
		if (body["additionalData"]) data["additionalData"] = JSON.stringify(body["additionalData"]);
		if (body["solutionData"]) data["solutionData"] = JSON.stringify(body["solutionData"]);
		if (body["setupData"]) data["setupData"] = JSON.stringify(body["setupData"]);
		
		var TargetModel = pApp.findPuzzleModel(apiKey);
		TargetModel.update({_id: puzzleId}, data, function(e, puzzle) {
			if(e) err.send_error(err.DB_ERROR, res);
			else if(!puzzle) err.send_error(err.PUZZLE_DOESNT_EXIST, res);
			else {
				res.send({puzzle_id: puzzleId, success: true});
			}
		});
	} else err.send_error(err.MISSING_INFO, res);
};

//
// picks random puzzle for the user
//
var pickRandomPuzzle = function(weightedDocs, weightedTotal) {
	var random = Math.random() * weightedTotal;
	for (var i = 0; i<weightedDocs.length; i++) {
		random = random - weightedDocs[i].weight;
		if (random <= 0) {
			return weightedDocs[i].puzzle;
		}
	}
	return null;
};

var minRatingDifference = 300;
var userLikesWeight = 10;

///////////////////////////
//      Suggestion      //
/////////////////////////

//
// suggestions based on ratings
//
exports.suggest = function(req, res) {
	var user = req.user;
	if(!user) err.send_error(err.MISSING_INFO, res);
	var userRating = req.user.rating;
		
		var ScoreModel = pApp.scoreModel(req.apiKey);
		
		ScoreModel.find({user: req.user._id}, function(e, docs) {
			if (e) {
				error.send_error(error.DB_ERROR, res, err.message);
				return;
			}
			var takenPuzzles = [];
			for (var i = 0; i<docs.length; i++) {
				takenPuzzles.push(docs[i].puzzle);
			}
			
			var TargetModel = pApp.findPuzzleModel(req.apiKey);
			
			TargetModel
				.where('rating')
				.gte(userRating - minRatingDifference)
				.lte(userRating + minRatingDifference)
				.where('_id').nin(takenPuzzles)
				.where('removed', false)
				.run(function(e, docs) {
					if (e) {
						if(e) console.log("[puzzle] " + e);
						err.send_error(err.DB_ERROR, res);
					} else if (docs.length == 0 || docs == null) { //return the closest puzzle
						TargetModel.where('rating').gte(userRating).where('_id').nin(takenPuzzles).where('removed', false).asc('rating').run(function(e, docs) {
							if (e) {
								err.send_error(err.DB_ERROR, res, e.message);
								return;
							}
							var higher = null;
							if (docs.length > 0) {
								higher = docs[0];
							}
							TargetModel.where('rating').lte(userRating).where('_id').nin(takenPuzzles).where('removed', false).desc('rating').run(function(e, docs) {
								if (e) {
									err.send_error(err.DB_ERROR, res, e.message);
									return;
								}
								var lower = null;
								if (docs.length > 0) {
									lower = docs[0];
								}
								if (lower == null && higher  == null) {
									err.send_error(err.NO_PUZZLES, res);
								} else if (lower == null) {
									res.send(JSON.stringify(higher));
								} else if (higher == null) {
									res.send(JSON.stringify(lower));
								} else if (Math.abs(userRating-higher.rating) > Math.abs(userRating-lower.rating)) {
									res.send(JSON.stringify(lower));
								} else {
									res.send(JSON.stringify(higher));
								}
							});
						});
					} else {
						var weightedDocs = [];
						var weightedTotal = 0;
						for (var i = 0; i<docs.length; i++) {
							var _puzzle = docs[i];
							var container = {};
							container.puzzle = _puzzle;
							if (_puzzle.taken == 0) {
								container.weight = Math.abs(_puzzle.rating-user.rating)/minRatingDifference;
							} else {
								container.weight = Math.abs(_puzzle.rating-user.rating)/minRatingDifference + Math.min(1, userLikesWeight*(_puzzle.likes-_puzzle.dislikes)/_puzzle.taken);
							}
							weightedTotal += container.weight;
							weightedDocs.push(container);
						}
						var puzzle = pickRandomPuzzle(weightedDocs, weightedTotal);
						
						res.send(JSON.stringify(puzzle));
					}
				});
		});
};

//
// gets the puzzles created by a user
//
exports.getUserPuzzles = function(req, res) {
	var user_id = req.params.id;
	db.UserModel.findOne( { "_id": user_id }, function(err, userDoc) {
		if (err) err.send_error(err.DB_ERROR, res);
		else if (!userDoc) {
			err.send_error(err.NO_MATCHING_USER, res);
		}
		else {
			
			// query specific model by apiKey to find
			// the puzzles.
			
			var apiKey = _u.stripNonAlphaNum(req.apiKey);
			var TargetModel = pApp.findPuzzleModel(apiKey);
			var query = {"creator" : userDoc.id};
			TargetModel.find(query, function(e, docs) {
				if(e) err.send_error(err.DB_ERROR, res);
				else if(!docs) {
					err.send_error(err.NO_PUZZLES, res);
				}
				else {
					for (var i = 0; i<docs.length; i++) {
						docs[i].setupData = undefined;
						docs[i].solutionData = undefined;
					}
					res.send(JSON.stringify(docs));
				}
			});
		}
	});
};

///////////////////////
//      Take        //
/////////////////////

//
// "takes" a puzzle + adjusts rating
// need to be passed in the auth token
// of the user who we claim is taking
// the puzzle
//
exports.take = function(req, res) {
	var token = _u.stripNonAlphaNum(req["authToken"]);
	if(token) {
		UserModel.findOne({authToken: token}, function(e, doc) {
			if(!e && doc) takeCB(req, res, doc);
			else {
				if(e) {
					console.log(e);
					err.send_error(err.DB_ERROR, res);
				}
				if(!doc) {
					console.log("[DB] couldn't find user with authToken " + token);
					err.send_error(err.NO_MATCHING_USER, res);
				}
			}
		});
	} else {
		err.send_error(err.MISSING_INFO, res);
	}
};

//
// callback after user has been
// presumably found
//
function takeCB(req, res, user) {
	var puzzleID = _u.stripNonAlphaNum(req.params.id);
	var apiKey = _u.stripNonAlphaNum(req.apiKey);
	var TargetModel = pApp.findPuzzleModel(apiKey);
	
    TargetModel.update({_id: puzzleID}, {$inc: {taken: 1}}, function(e, numAffected) {
        if (e) {
            console.log("[DB] " + e);
            err.send_error(err.DB_ERROR, res);
        }
        else if (numAffected == 0) {
            console.log("[DB] didn't find puzzle with apikey" + puzzleID);
            err.send_error(err.PUZZLE_DOESNT_EXIST, res);
        }
        else {
            req.user = user; // save the user object before continuing
            adjust(req, res, TargetModel);
        }
    });
}

//
// finds and adjusts ratings of user and puzzle
// accordingly
//
function adjust(req, res, TargetModel) {
    var user = req.user
        , puzzleID = _u.stripNonAlphaNum(req.params.id)
        , url_parts = url.parse(req.url, true)
        , notRated = url_parts.query.notRated == 'true';

    TargetModel.findById(puzzleID, function(_e, puzzle) {
        adjustRating(req, res, user.rating, puzzle, !notRated);
    });
}

//
// adjusts player rating based on new data.
// @param playerRating is current player rating.
// @param doc refers to a puzzle document
//
function adjustRating(req, res, playerRating, puzzle, isRated) {
	var user = req.user;
	
	var puzzleRating = puzzle.rating;
	var puzzleRD = puzzle.rd;
	var playerRD = user.rd;
	var score = req.body.score;

	var newPlayerRating;
	var newPuzzleRating;
	var newPlayerRD;
	var newPuzzleRD;
	
	if (isRated) {
		newPlayerRating = glicko.newRating(playerRating, puzzleRating, playerRD, puzzleRD, score);
		newPuzzleRating = glicko.newRating(puzzleRating, playerRating, puzzleRD, playerRD, 1-score);
		newPlayerRD = glicko.newRD(playerRating, puzzleRating, playerRD, puzzleRD, score, false);
		newPuzzleRD = glicko.newRD(puzzleRating, playerRating, puzzleRD, playerRD, 1-score, true);
	} else {
		newPlayerRating = playerRating;
		newPuzzleRating = puzzleRating;
		newPlayerRD = playerRD;
		newPuzzleRD = puzzleRD;
	}
	
	puzzle.rd = newPuzzleRD;
	puzzle.rating = newPuzzleRating;
	
	user.rd = newPlayerRD;
	user.rating = newPlayerRating;
	
	var ScoreModel = pApp.scoreModel(req.apiKey);
	var scoreInstance = new ScoreModel();
	scoreInstance.user = user._id;
	scoreInstance.puzzle = _u.stripNonAlphaNum(req.params.id);
	scoreInstance.value = score;
	scoreInstance.puzzleRating = newPuzzleRating;
	scoreInstance.userRating = newPlayerRating;
	
	scoreInstance.save(function(err) {
		//do nothing. If err, don't worry about it. It won't affect too much.
	});
	
	user.save(function(err) {
		if (err) err.send_error(err.DB_ERROR, res);
		else {
			puzzle.save(function(err) {
				if (err) err.send_error(err.DB_ERROR, res);
				else {
					var retVal = {success : true
						, newPlayerRD: newPlayerRD
						, newPuzzleRD : newPuzzleRD
						, newPlayerRating : newPlayerRating
						, newPuzzleRating : newPuzzleRating
						, playerRatingChange : newPlayerRating - playerRating
						, puzzleRatingChange : newPuzzleRating - puzzleRating};
					res.send(JSON.stringify(retVal));
				}
			});
		}
	});
}

///////////////////////////////
// 		Likes / Dislikes 	//
/////////////////////////////

exports.like = function (req, res) {
	var puzzle_id = _u.stripNonAlphaNum(req.body['puzzle_id'])
		, apiKey = _u.stripNonAlphaNum(req.apiKey)
		, TargetModel = pApp.findPuzzleModel(apiKey);

	console.log("[puzzle] : liking puzzle with id " + puzzle_id);
	TargetModel.update({_id:puzzle_id}, {$inc : {likes: 1}}, {}, callback);
	function callback(e, numAffected) {
		if(!e) res.send({"success":true, "numAffected": numAffected});
		else err.send_error(err.PUZZLE_DOESNT_EXIST, res);
    }
};

exports.dislike = function (req, res) {
	var puzzle_id = _u.stripNonAlphaNum(req.body['puzzle_id'])
		, api_key = _u.stripNonAlphaNum(req.apiKey)
		, TargetModel = pApp.findPuzzleModel(api_key);
		
	console.log("[puzzle] : disliking puzzle with id " + puzzle_id);
	TargetModel.update({_id:puzzle_id}, {$inc : {dislikes: 1}}, {}, callback);
	function callback(e, numAffected) {
		if(!e) res.send({"success":true, "numAffected": numAffected});
		else err.send_error(err.PUZZLE_DOESNT_EXIST, res);
	}
};
