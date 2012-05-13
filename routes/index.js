
/*
 * Module requires.
 */

var db = require('./../db.js');

var APIkeyModel = db.APIkeyModel;

exports.index = function(req, res){
  res.render('index',
              { title: 'Express' })
};

//
// generates and returns String denoting
// api token so we can actually test
// this whole thing.
//
exports.getKey = function (req, res) {
    var key = new APIkeyModel();
    console.log("[route/index] New Apikey " + key.toString());
    key.save();
    res.send(key.value);
};
