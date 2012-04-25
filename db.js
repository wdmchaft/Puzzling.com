/**
 * Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// I think if you have a new database name,
// you create a new databse with connect?
// Maybe we want a new database for each app? => database name = apikey?

var DATABASE_NAME = 'test';

// Requires
var mongoose = require('mongoose'),
          db = mongoose.connect('mongodb://localhost/' + DATABASE_NAME),
      Schema = mongoose.Schema,
    ObjectID = Schema.ObjectId;

App = new Schema({
				 puzzles : [ObjectID]
				 ,	user : [ObjectID]
				 ,	name : String
				 ,	apiKey : String
				 });

FriendRequest = new Schema({
                  to : ObjectID
                , from : ObjectID
});

User = new Schema({
				  name : String
				  ,	password : String
                  , salt : String
				  ,	authToken : String
				  ,	friendRequests : [ObjectID]	    /* requests */
				  ,	friends : [ObjectID]
				  ,	rating : Number				    /* Ability at puzzles */
				  , rd : Number					    /* Rating deviation */
                  , user_data : String              /* JSON data */
				  });

Puzzle = new Schema({
					puzzleID : ObjectID /* QUESTION: HOW DO YOU SET THIS. SHOULD THIS JUST BE THE _id WHICH COMES WITH THE OBJECT? */
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
				   });

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

//All the names of collections must end in s. Otherwise, they add one for you.
exports.AppModel = mongoose.model('apps', App);
exports.FriendRequestModel = mongoose.model('friend_requests', FriendRequest);
exports.PuzzleModel = mongoose.model('puzzles', Puzzle);
exports.UserModel = mongoose.model('users', User);
exports.ObjectID = ObjectID;

//var simple = new Schema({
//						  a    : String });
//var MyModel = mongoose.model('simples', simple); //I cannot work out what the name of the model does.
//var instance = new MyModel();
//instance.a = 'hello';
//instance.save(function (err) {
//			  //
//			  });
//
//MyModel.find({}, function (err, docs) {
//			 console.log(docs);
//});
//
//exports.userModel = function() { //I think if you export each different model constructor, you can access anything you need to in the database
//	return MyModel;
//};
//
//exports.puzzleModel = MyModel; //actually, does this work? If so it'll be clearer. Above you'd need to do new db.userModel()()
//
