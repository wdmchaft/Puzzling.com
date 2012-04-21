/**
 * Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

var MAX_PUZZLE_RD = 350;
var MAX_PLAYER_RD = 350;
var MIN_PUZZLE_RD = 30;
var MIN_PLAYER_RD = 60;

var q = function() {
	return Math.log(10)/400;
};

var d2 = function(playerRating, oppontentRating, playerRD, opponentRD, score) {
	var left = q()*q()*g(oppontentRating)*g(oppontentRating);
	var expected = E(playerRating, oppontentRating, opponentRD);
	var right = expected * (1-expected);
	return Math.pow(left*right, -1);
};

var E = function(playerRating, oppontentRating, opponentRD) {
	var exponent = -1*g(opponentRD)*(playerRating-oppontentRating)/400;
	var denominator = 1 + Math.pow(10, exponent);
	return 1/denominator;
};

var g = function(rd) {
	var inside = 1 + (3*q()*q()*rd*rd/Math.pow(Math.PI, 2));
	var denominator = Math.sqrt(inside);
	return 1/denominator;
};

exports.newRating = function(playerRating, oppontentRating, playerRD, opponentRD, score) { //score 1 for player win, 0 for opponent win
	playerRating = Number(playerRating); //convert everything to doubles
	oppontentRating = Number(oppontentRating);
	playerRD = Number(playerRD);
	opponentRD = Number(opponentRD);
	score = Number(score);
	if (isNaN(playerRD) || isNaN(oppontentRating) || isNaN(playerRating) || isNaN(opponentRD) || isNaN(score) || score < 0 || score > 1) {
		return playerRating;
	}
	var changeLeft = q() / (1/(playerRD*playerRD) + 1 / d2(playerRating, oppontentRating, playerRD, opponentRD, score));
	var changeRight = g(playerRD)*(score - E(playerRating, oppontentRating, opponentRD));
	var change = changeLeft * changeRight;
	return playerRating + change;
};

exports.newRD = function(playerRating, oppontentRating, playerRD, opponentRD, score, isPuzzle) {
	var inside = 1/Math.pow(playerRD, 2) + 1/d2(playerRating, oppontentRating, playerRD, opponentRD, score);
	var next = 1/inside;
	var newRD = Math.sqrt(next);
	if (isPuzzle) {
		return Math.max(MIN_PUZZLE_RD, Math.min(MAX_PUZZLE_RD, newRD));
	} else {
		return Math.max(MIN_PLAYER_RD, Math.min(MAX_PLAYER_RD, newRD));
	}
};