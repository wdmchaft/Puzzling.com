/**
 * Created with JetBrains WebStorm.
 * User: jimzheng
 * Date: 5/2/12
 * Time: 7:30 PM
 * To change this template use File | Settings | File Templates.
 */

var hash = require('./../hash')
    , err = require('./../error.js')
    , db = require('./../db')
    , _u = require('./../utils.js');

var pApp = db.pAppModel;

//
// Declare exports in advance
//
exports.create = createApp;
exports.delete = deleteApp;
exports.getApp = getApp;

//
// get all apps belonging to certain api key.
//

function getApp(req, res) {
    var userKey = _u.stripNonAlphaNum(req.apiKey);
    pApp.findByKey(userKey, function (e, apps) {
        if (!e) {
            res.send(JSON.stringify(apps));
        } else {
            console.log('[papp] ' + e.toString());
            err.sendError(err.transactionError, res);
        }
    });
}

//
// Create - create a new app.
// Does not mean creating a new puzzle;
// to do that, look at the puzzles API.
//

function createApp(req, res) {
    var nApp = new pApp();
    nApp.apiKey = _u.stripNonAlphaNum(req.apiKey);

    nApp.name = req.query.name || req.params.name || req.body.name;
    console.log('[papp] creating new application ' + nApp.name);
    nApp.save(function(e) {
        if (!e) res.send(JSON.stringify({puzzle_id: nApp._id, success:true}));
        else {
           console.log('[papp] ' + e.toString());
           err.sendError(err.transactionError, res);
        }
    });
}

//
// Delete our app along with its collection
//

function deleteApp(req, res) {
    var key = _u.stripNonAlphaNum(req.apiKey);

    console.log("[papp] Trying to delete app with key " + key);
    // deletes app, then collection of all puzzles.
    pApp.findOne({apiKey : key}, function(e, found) {
        if(!e) {
            // drop the collection along
            // with all its docs; if we
            // can't, then let it persist
            // in the backend and log the
            // error. In the future, have
            // an async task look at the
            // outputs and manually call
            // drop on these collections.
            var PuzzleModel = pApp.findPuzzleModel(key);
            var inst = new PuzzleModel();
            inst.collection.drop(function(e) {
                if(e) console.log(e);
                else console.log("[papp] successfully dropped collection puzzle" + key)
            });
            res.send({"success": true});
        }
        else err.sendError(err.transactionError, res);
    });
}