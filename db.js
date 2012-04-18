/**
 * Created by JetBrains WebStorm.
 * User: plivesey
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

var DATABASE_NAME = 'test'; //I think if you have a new database name, you create a new databse with connect? Maybe we want a new database for each app? => database name = apikey?

var mongoose = require('mongoose');
var db = mongoose.connect('mongodb://localhost/' + DATABASE_NAME);
var Schema = mongoose.Schema
, ObjectId = Schema.ObjectId;

var simple = new Schema({
						  a    : String });
var MyModel = mongoose.model('simple', simple); //I cannot work out what the name of the model does.
var instance = new MyModel();
instance.a = 'hello';
instance.save(function (err) {
			  //
			  });

MyModel.find({}, function (err, docs) {
			 console.log(docs);
});

exports.userModel = function() { //I think if you export each different model constructor, you can access anything you need to in the database
	return MyModel;
};

exports.puzzleModel = MyModel; //actually, does this work? If so it'll be clearer. Above you'd need to do new db.userModel()()