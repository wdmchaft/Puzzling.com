/**
 * Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

var DATABASE_NAME = 'test';

/**
 * Requirements
 */
var mongoose = require('mongoose')
    , hash = require('./hash')
    , _u = require('./utils.js');

/**
 * Database-related things
 */
var conn = mongoose.connect('mongodb://localhost/' + DATABASE_NAME)
    , Schema = mongoose.Schema
    , ObjectID = Schema.ObjectId;

/**
 * Schema Definition for:
 * :: ApiKey
 * :: FriendReqeust
 * :: Friends
 * :: Users
 * :: pApp (Puzzling.com app)
 * :: Puzzle
 * :: Score
 * :: Comments
 * :: Message
 */

APIkey = new Schema({
    // actual value of key used by _id.
    date : { "type": Date, "default": Date.now }    /* can let you expire tokens */
});

APIkey.virtual('value').get(function () {
        return this._id;
});

APIkey.methods.duplicate = function() {
    return {_id : this._id, date : this.date};
};

//
// Friends
// Model for handling friendships
//
FriendRequest = new Schema({
        to : ObjectID
    ,   from : ObjectID
});

//
// Basic user
//
User = new Schema({
        username : String
    ,   password : String
    ,   salt : String
    ,   authToken : String
    ,   friendRequests : [ObjectID]	    /* requests */
    ,   friends : [ObjectID]
    ,   rating : Number				    /* Ability at puzzles */
    ,   rd : Number					    /* Rating deviation */
    ,   user_data : String              /* JSON data */
    });

User.methods.generate_password = function(input, salt) {
    return hash.sha1(input, salt);
};

User.methods.set_password = function(pw) {
    var salt = "abcd" + Math.floor(Math.random() * 100000);
    this.salt = salt;
    this.password = this.generate_password(pw, salt);
};

User.methods.check_password = function(pw) {
    return (this.generate_password(pw, this.salt) === this.password);
};

// separate this from the APIkey field
// so that we can integrate in the future
// there's a 1:1 mapping between pApps and
// apiKeys for now.

pApp = new Schema({
    apiKey  : String           /* apiKey: the only thing uniquely identifying this entry */
    ,   name    : String           /* optional; not used by the backend */
    ,   users   : [User]
});

//
// creates puzzle by dynamically specifying a
// collection name as 'puzzleAPIKEY', where
// APIKEY is the api key used by the user to
// create this model.
//
pApp.methods.createPuzzle = function () {
    var PuzzleModel = mongoose.model('puzzle' + this.apiKey, Puzzle);
    var instance;
    if (arguments.length > 0) {
        instance = new PuzzleModel(arguments[0]);
    } else {
        instance = new PuzzleModel();
    }
    console.log("[DB] Creating new puzzle with apikey " + this.apiKey);
    instance.save();
    return instance;
};

// findPuzzleModel
//
// valuable helpers that gets a
// collection model from an apiKey
//
pApp.methods.findPuzzleModel = function() {
    return mongoose.model('puzzle' + this.apiKey, Puzzle);
};

pApp.statics.findPuzzleModel = function(apiKey) {
    return mongoose.model('puzzle' + apiKey, Puzzle)
};

//
// finds the apps with given token
//
pApp.statics.findByKey = function (authToken, cb) {
    authToken = _u.stripNonAlphaNum(authToken);
    return pApp.find({_id : authToken}, cb);
};

//
// Basic puzzle; useless as its own schema but
// useful when adding entries into one of the several
// puzzleX collections.
//

Puzzle = new Schema({
        puzzleID : ObjectID
    ,   name : String               /* forgot to include in original specs */
    ,	creator: ObjectID
    ,	meta : String			    /* JSON; additional metadata */
    ,	setupData : String			/* JSON of puzzle’s main data */
    ,	solutionData: String		/* JSON of solution */
    ,	type : String		        /* user-defined enum */
    ,	likes : Number			    /* number of upvotes */
    , 	dislikes : Number			/* number of downvotes */
    ,	taken : Number			    /* rating == (likes / taken) */
    , 	timestamp : Date			/* date created */
    ,	rating : Number			    /* difficulty rating */
    ,   rd : Number					/* Rating deviation */
    });

// Just in case

PuzzleAdditionalData = new Schema({
        puzzle : ObjectID
    ,	creator : ObjectID
    ,	value : String			/* JSON Data */
    ,	timestamp : Date
    });

Score = new Schema({
				   user : ObjectID
				   ,	puzzle : ObjectID
				   ,	value: Number
				   ,	timestamp : Date
				   ,	timeTaken : Date			/* time difference */
					 ,  puzzleRating : Number
					 ,  userRating : Number
				   });
					 
pApp.methods.scoreModel = function(apiKey) {
		return mongoose.model('score' + apiKey, Score);
};

pApp.statics.scoreModel = function(apiKey) {
    return mongoose.model('score' + apiKey, Score);
};


Comment = new Schema({
        user : ObjectID
     ,	puzzle : ObjectID
     ,	value : String
     ,	timestamp : Date
     });

Message = new Schema({
        to : ObjectID
     ,	from : ObjectID
     ,	value : String
     ,	timestamp : Date
     });


/**
 * Exports
 */

    // Models
    // All the names of collections must end in 's'.
    // Names are camelCase compliant. Otherwise,
    // they add one for you.

exports.conn = conn;
exports.APIkeyModel = mongoose.model('APIkey', APIkey);
exports.pAppModel = mongoose.model('apps', pApp);
exports.UserModel = mongoose.model('users', User);
exports.PuzzleModel = mongoose.model('puzzles', Puzzle);
exports.FriendRequestModel = mongoose.model('friendRequests', FriendRequest);
exports.ObjectID = mongoose.Types.ObjectId;