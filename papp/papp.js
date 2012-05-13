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
            found.remove();
            db.dropCollection("puzzles" + key, function(e) {
                var status = {apiKey: key, success: true, dropped : false};
                if (e) {
                    console.log('[papp] ' + e.toString());
                    res.send(JSON.stringify(status));
                }
                else {
                    status['dropped'] = true;
                    res.send(JSON.stringify(status));
                }
            });
        }
        else err.sendError(err.transactionError, res);
    });
}
