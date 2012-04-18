
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , papp = require('./routes/papp')
  , user = require('./user')
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
/*
 * Express maps javascript regex's to pages loaded in from routes module.
 * App.get takes in two parameters: the regex to match the url, and an object
 * to serve from the routes module.
 * NOTE: These regexes are compiled down to regex literals, but you can also
 * choose to pass literal regex's for more complex things.
 * For more info see expressjs.com/guide.html/#routing
 * and look up "expressjs route-separation" for an example on Github.
 */

// General Site

app.get('/', routes.index);

// Users
// NOTE : for this to work, comment out
// the line in app.configure view engine 'jade'
// and uncomment the line app.configure view engine 'ejs'
// all others won't work.
// Haven't yet figured out how to render two kinds of views
// at once...

app.all('/users', user.list);
app.all('/user/:id/:op?', user.load);
app.get('/user/:id', user.view);
app.get('/user/:id/view', user.view);
app.get('/user/:id/edit', user.edit);
app.put('/user/:id/edit', user.update);

//Puzzle

app.post('/puzzle', puzzle.create);
app.post('/puzzle/:id', puzzle.takePuzzle);
app.get('/puzzle/:id', puzzle.getPuzzle);
app.get('/puzzle/user/:id', puzzle.getUserPuzzles);


// Puzzling apps - Examples of POST / GET parameters

app.get('/papp', papp.paramExampleGET);
app.post('/papp', papp.paramExamplePOST);

/*
 * Start up our server
 */
app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
