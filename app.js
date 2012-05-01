
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , login = require('./users/login')
  , puzzle = require('./puzzle')
  , db = require('./db');

/* Creates an HTTP Server as our app variable.
 * To create HTTP, do the same but pass in a key.cert.
 */
var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  //app.set('view engine', 'jade');
  app.set('view engine', 'ejs');

  /* Middlewares */
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public')); // media files
});

/*
 * we can configure Express server to have two settings --
 * dev and production.
 */
app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});
app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

// General Site
app.get('/', routes.index);

// Login
app.all('/login', login.login);

// app.get('/friend', friend.list);
// app.post('/friend/:id/:id', friend.request);

// Puzzle
app.post('/puzzle', puzzle.create);
app.post('/puzzle/:id', puzzle.takePuzzle);
app.get('/puzzle/:id', puzzle.getPuzzle);
app.get('/puzzle/user/:id', puzzle.getUserPuzzles);
app.get('/puzzle', puzzle.puzzleSuggestion);

// Start up our server
app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
