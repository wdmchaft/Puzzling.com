/**
* Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

var authentication = require('./authentication')
, glicko = require('./glicko')
, url = require('url')
, db = require('./db')
, error = require('./error.js');

exports.create = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var setupData = req.body.setupData;
			var solutionData = req.body.solutionData;
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
			puzzleInstance.rd = 250;
			puzzleInstance.creator = user._id;
			puzzleInstance.save(function(err) {
				if (err) {
					error.send_error(error.DB_ERROR, res, err.message);
					return;
				}
				var returnData = req.body;
				returnData.puzzle_id = puzzleInstance._id;
				returnData.creator = puzzleInstance.creator;
				returnData.timestamp = puzzleInstance.timestamp;
				returnData.likes = puzzleInstance.likes;
				returnData.dislikes = puzzleInstance.dislikes;
				returnData.rating = puzzleInstance.rating;
				res.send(JSON.stringify(returnData));
			});
		}
	});
};

var pickRandomPuzzle = function(weightedDocs, weightedTotal) {
	var random = Math.random()*weightedTotal;
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

//TODO: Error messages, no docs returned, check user has not taken or created the puzzle
exports.puzzleSuggestion = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var userRating = user.rating;
			db.ScoreModel.find({user: user._id}, function(err, docs) {
				if (err) {
					error.send_error(error.DB_ERROR, res, err.message);
					return;
				}
				var takenPuzzles = [];
				for (var i = 0; i<docs.length; i++) {
					takenPuzzles.push(docs[i].puzzle);
				}
				db.PuzzleModel.where('rating').gte(userRating-minRatingDifference).lte(userRating+minRatingDifference).where('_id').nin(takenPuzzles).run(function(err, docs) {
					if (err) {
						error.send_error(error.DB_ERROR, res, err.message);
						return;
					}
					if (docs.length == 0 || docs == null) { //return the closest puzzle
						db.PuzzleModel.where('rating').gte(userRating).where('_id').nin(takenPuzzles).asc('rating').run(function(err, docs) {
							if (err) {
								error.send_error(error.DB_ERROR, res, err.message);
								return;
							}
							var higher = null;
							if (docs.length > 0) {
								higher = docs[0];
							}
							db.PuzzleModel.where('rating').lte(userRating).where('_id').nin(takenPuzzles).desc('rating').run(function(err, docs) {
								if (err) {
									error.send_error(error.DB_ERROR, res, err.message);
									return;
								}
								var lower = null;
								if (docs.length > 0) {
									lower = docs[0];
								}
								if (lower == null && higher  == null) {
									error.send_error(error.NO_PUZZLES, res);
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
							var puzzle = docs[i];
							var container = {};
							container.puzzle = puzzle;
							if (puzzle.taken == 0) {
								container.weight = Math.abs(puzzle.rating-user.rating)/minRatingDifference;
							} else {
								container.weight = Math.abs(puzzle.rating-user.rating)/minRatingDifference + Math.min(1, userLikesWeight*(puzzle.likes-puzzle.dislikes)/puzzle.taken);
							}
							weightedTotal += container.weight;
							weightedDocs.push(container);
						}
						var puzzle = pickRandomPuzzle(weightedDocs, weightedTotal);
						res.send(JSON.stringify(puzzle));
					}
				});
			});
		}
	});
};

exports.getPuzzle = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var puzzleID = req.params.id;
			db.PuzzleModel.findOne( { "_id": puzzleID }, function(err, doc) {
				if (err) {
					error.send_error(error.DB_ERROR, res, err.message);
					return;
				}
				if (doc == null) {
					res.statusCode = 400;
					res.send( {statusCode: 400, error: "no_such_puzzle_exists" } );
				} else {
					res.send(JSON.stringify(doc));
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
					error.send_error(error.DB_ERROR, res, err.message);
					return;
				}
				if (doc == null) {
					res.statusCode = 400;
					res.send( {statusCode: 400, error: "no_such_puzzle_exists" } );
				} else {
					db.PuzzleModel.find( { "creator" : doc._id }, function(err, docs) {
						if (err) {
							error.send_error(error.DB_ERROR, res, err.message);
							return;
						}
						res.send(JSON.stringify(docs));
					});
				}
			});
		}
	});
};

exports.takePuzzle = function(req, res) {
	authentication.verifyRequestAuthtokenAndAPI(req, res, function(success, user) {
		if (success) {
			var url_parts = url.parse(req.url, true);
			var notRated = url_parts.query.notRated == 'true';
			console.log("string: " + url_parts.query.notRated + " bool: " + notRated);
			var playerRating = user.rating;
			var puzzleID = req.params.id;
			if (!puzzleID) {
				res.statusCode = 400;
				res.send( {statusCode: 400, error: "no_puzzle_id_included" } );
			} else {
				db.PuzzleModel.findOne( { "_id": puzzleID }, function(err, doc) {
					if (err) {
						error.send_error(error.DB_ERROR, res, err.message);
						return;
					} else if (doc == null) {
						error.send_error(error.PUZZLE_DOESNT_EXIST, res);
						return;
					}
					var puzzleRating = doc.rating;
					var puzzleRD = doc.rd;
					var playerRD = user.rd;
					var score = req.body.score;
					
					var newPlayerRating;
					var newPuzzleRating;
					var newPlayerRD;
					var newPuzzleRD;
					
					if (notRated) {
						var newPlayerRating = playerRating;
						var newPuzzleRating = puzzleRating;
						var newPlayerRD = playerRD;
						var newPuzzleRD = puzzleRD;
					} else {
						newPlayerRating = glicko.newRating(playerRating, puzzleRating, playerRD, puzzleRD, score);
						newPuzzleRating = glicko.newRating(puzzleRating, playerRating, puzzleRD, playerRD, 1-score);
						newPlayerRD = glicko.newRD(playerRating, puzzleRating, playerRD, puzzleRD, score, false);
						newPuzzleRD = glicko.newRD(puzzleRating, playerRating, puzzleRD, playerRD, 1-score, true);
					}
					
					doc.rd = newPuzzleRD;
					doc.rating = newPuzzleRating;
					user.rd = newPlayerRD;
					user.rating = newPlayerRating;
					
					var scoreInstance = new db.ScoreModel();
					scoreInstance.user = user._id;
					scoreInstance.puzzle = doc._id;
					scoreInstance.value = score;
					scoreInstance.puzzleRating = newPuzzleRating;
					scoreInstance.userRating = newPlayerRating;
					
					scoreInstance.save(function(err) {
						//do nothing. If err, don't worry about it. It won't affect too much.
					});
					
					user.save(function(err) {
						if (err) {
							error.send_error(error.DB_ERROR, res, err.message);
							return;
						}
						doc.save(function(err) {
							if (err) {
								error.send_error(error.DB_ERROR, res, err.message);
								return;
							}
							var returnValue = { "newPlayerRating" : newPlayerRating, "newPuzzleRating" : newPuzzleRating, "newPlayerRD": newPlayerRD, "newPuzzleRD" : newPuzzleRD, "playerRatingChange" : newPlayerRating - playerRating, "puzzleRatingChange" : newPuzzleRating - puzzleRating };
							res.send(JSON.stringify(returnValue));
						});
					});
				});
			}
		}
	});
}

/* v2
exports.deletePuzzle = function(req, res) {
	var puzzleId = req.body.puzzle_id || undefined;
	if(puzzleId) {
		db.PuzzleModel.findOne({"_id" : puzzleId}, function(e, docs) {
			if(!e) { err.send_error(err.NOT_FOUND, res); return; }
			res.send({"puzzle_id" : puzzleId, "status" : "SUCCESS"});
		});
	} else {
		err.send_error(err.MISSING_INFO, res); return;
	}
}
*/

