/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 1:09 PM
 * To change this template use File | Settings | File Templates.
 */

/*
 * Example for handling GET parameters
 *
 * req.query used for GET parameters only.
 * See below for POST params.
 *
 */
exports.paramExampleGET = function(req, res) {
    var id = req.query["id"];

    if(id) { res.send("id is " + id); }
    else { res.send("no id!"); }

}

/*
 * Example of bodyParser middleware.
 *
 * Tested with:
 * > curl -d "id=value1" http://localhost:3000/papp
 *
 */

exports.paramExamplePOST = function(req, res) {
    var id = req.body["id"];

    if(id) { res.send("POST id is " + id); }
    else { res.send("no POST id!"); }

}
