/**
 * Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

var authentication = require('./authentication');
var url = require('url');
var glicko = require('./glicko');
var db = require('./db');

exports.create = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var setupData = req.body.setupData;
			var solutionData = req.body.solutionData;
			var additionalData = req.body.additionalData;
			var puzzleType = req.body.puzzleType;
			var puzzleName = req.body.name;
			var puzzleType = req.body.type;
			
			var puzzleInstance = new db.PuzzleModel();
			puzzleInstance.name = puzzleName;
			puzzleInstance.setupData = JSON.stringify(setupData);
			puzzleInstance.solutionData = JSON.stringify(solutionData);
			puzzleInstance.type = puzzleType;
			puzzleInstance.likes = 0;
			puzzleInstance.dislikes = 0;
			puzzleInstance.taken = 0;
			puzzleInstance.timestamp = new Date();
			puzzleInstance.rating = 1500;
			puzzleInstance.rd = 350;
			puzzleInstance.creator = user._id;
			puzzleInstance.save(function(err) {
				if (err) {
					res.statusCode = 500;
					res.send( { statusCode: 500, error : err} );
				} else {
					var returnData = req.body;
					returnData.puzzle_id = puzzleInstance._id;
					returnData.creator = puzzleInstance.creator;
					returnData.timestamp = puzzleInstance.timestamp;
					returnData.likes = puzzleInstance.likes;
					returnData.dislikes = puzzleInstance.dislikes;
					returnData.rating = puzzleInstance.rating;
					res.send(returnData);
				}
			});
		}
	});
};

exports.puzzleSuggestion = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			
		}
	});
};

exports.getPuzzle = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var puzzleID = req.params.id;
			db.PuzzleModel.findOne( { "_id": puzzleID }, function(err, doc) {
				if (err) {
					res.statusCode = 500;
					res.send( { statusCode: 500, error : err} );
				} else if (doc == null) {
					res.statusCode = 400;
					res.send( {statusCode: 400, error: "no_such_puzzle_exists" } );
				} else {
					res.send(doc);
				}
			});
		}
	});
};

exports.getUserPuzzles = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var user_id = req.params.id;
			db.UserModel.findOne( { "_id": user_id }, function(err, doc) {
				if (err) {
					res.statusCode = 500;
					res.send( { statusCode: 500, error : err} );
				} else if (doc == null) {
					res.statusCode = 400;
					res.send( {statusCode: 400, error: "no_such_puzzle_exists" } );
				} else {
					db.PuzzleModel.find( { "creator" : doc._id }, function(err, docs) {
						if (err) {
							res.statusCode = 500;
							res.send( { statusCode: 500, error : err} );
						} else {
							res.send(docs);
						}
					});
				}
			});
		}
	});
};

exports.takePuzzle = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var playerRating = user.rating;
			var puzzleID = req.body.puzzle_id;
			if (!puzzleID) {
				res.statusCode = 400;
				res.send( {statusCode: 400, error: "no_puzzle_id_included" } );
			} else {
				db.PuzzleModel.findOne( { "_id": puzzleID }, function(err, doc) {
					if (err) {
						res.statusCode = 500;
						res.send( { statusCode: 500, error : err} );
					} else if (doc == null) {
						res.statusCode = 400;
						res.send( {statusCode: 400, error: "no_such_puzzle_exists" } );
					} else {
						var puzzleRating = doc.rating;
						var puzzleRD = doc.rd;
						var playerRD = user.rd;
						var score = req.body.score;
						var newPlayerRating = glicko.newRating(playerRating, puzzleRating, playerRD, puzzleRD, score);
						var newPuzzleRating = glicko.newRating(puzzleRating, playerRating, puzzleRD, playerRD, 1-score);
						var newPlayerRD = glicko.newRD(playerRating, puzzleRating, playerRD, puzzleRD, score, false);
						var newPuzzleRD = glicko.newRD(puzzleRating, playerRating, puzzleRD, playerRD, 1-score, true);
						
						doc.rd = newPuzzleRD;
						doc.rating = newPuzzleRating;
						user.rd = newPlayerRD;
						user.rating = newPlayerRating;
						
						user.save(function(err) {
							if (err) {
								res.statusCode = 500;
								res.send( { statusCode: 500, error : err} );
							} else {
								doc.save(function(err) {
									if (err) {
										res.statusCode = 500;
										res.send( { statusCode: 500, error : err} );
									} else {
										var returnValue = { "newPlayerRating" : newPlayerRating, "newPuzzleRating" : newPuzzleRating, "newPlayerRD": newPlayerRD, "newPuzzleRD" : newPuzzleRD };
										res.send(returnValue);
									}
								});
							}
						});
					}
				});
			}
		}
	});
}

