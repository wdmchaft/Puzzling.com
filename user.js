/**
 * Created by JetBrains WebStorm.
 * User: jimzheng
 * Date: 4/12/12
 * Time: 12:57 PM
 * To change this template use File | Settings | File Templates.
 */

// Taken from Github.

// Fake user database

var users = [
    { name: 'TJ', email: 'tj@vision-media.ca' }
    , { name: 'Tobi', email: 'tobi@vision-media.ca' }
];

exports.list = function(req, res){
    res.render('users', { title: 'Users', users: users });
};

exports.load = function(req, res, next){
    var id = req.params.id;
    req.user = users[id];
    if (req.user) {
        next();
    } else {
        next(new Error('cannot find user ' + id));
    }
};

exports.view = function(req, res){
    res.render('users/view', {
        title: 'Viewing user ' + req.user.name
        , user: req.user
    });
};

exports.edit = function(req, res){
    res.render('users/edit', {
        title: 'Editing user ' + req.user.name
        , user: req.user
    });
};

exports.update = function(req, res){
    // Normally you would handle all kinds of
    // validation and save back to the db
    var user = req.body.user;
    req.user.name = user.name;
    req.user.email = user.email;
    res.redirect('back');
};