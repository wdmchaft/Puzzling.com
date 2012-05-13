
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , login = require('./users/login')
  , puzzle = require('./puzzle')
  , papp = require('./papp/papp')
  , user = require('./users/user')
  , auth = require('./authentication')
  , db = require('./db');

// Creates an HTTP Server as our app variable.
// To create HTTP, do the same but pass in a key.cert.

var app = module.exports = express.createServer();

/**
 * Configuration
 */

app.configure(function(){
  app.set('views', __dirname + '/views');
  // app.set('view engine', 'jade');
  app.set('view engine', 'ejs');

  // Middleware
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public')); // media files
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});
app.configure('production', function(){
  app.use(express.errorHandler());
});

/**
 * Routes
 */

// General Site

app.get('/', routes.index);
app.get('/getApiToken/f843c91381ffab599b09957f7480d3e9', routes.getKey);

// Login - Verbs handled internally

app.get('/login', auth.restrictByApi, login.get);
app.post('/login', auth.restrictByApi, login.post);
app.put('/login', auth.restrict, login.put);
app.delete('/login', auth.restrict, login.delete);
app.get('/user/:name', auth.restrict, login.getData);

// Friends

// app.get('/friend', friend.list);
// app.post('/friend/:id/:id', friend.request);

// Papp

app.post('/papp', auth.restrict, papp.create);
app.get('/papp/:name', auth.restrict, papp.getApp);
app.delete('/papp/:name', auth.restrict, papp.delete);

// Puzzle

app.get('/puzzle', auth.restrict, puzzle.suggest);
app.post('/puzzle', auth.restrict, puzzle.create);
app.del('/puzzle', auth.restrict, puzzle.delete);
app.get('/puzzle/:id', auth.restrict, puzzle.get);
app.get('/puzzle/user/:id', auth.restrict, puzzle.getUserPuzzles);
app.post('/puzzle/:id', auth.restrict, puzzle.take);
app.put('/puzzle/update', auth.restrictByApi, puzzle.update);

// Start up our server
app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
