var express = require('express'),
    async = require('async'),
    pg = require("pg"),
    cookieParser = require('cookie-parser'),
    bodyParser = require('body-parser'),
    methodOverride = require('method-override'),
    app = express(),
    server = require('http').Server(app),
    io = require('socket.io')(server);

io.set('transports', ['polling']);

var port = process.env.PORT || 4000;

io.sockets.on('connection', function (socket) {

  socket.emit('message', { text : 'Welcome!' });

  socket.on('subscribe', function (data) {
    socket.join(data.channel);
  });
});

async.retry(
  {times: 1000, interval: 1000},
  function(callback) {
    //for development
    //pg.connect('postgres://postgres:pg8675309@store/postgres', function(err, client, done) {
    
    //for production
    pg.connect('postgres://postgres:pg8675309@10.244.2.36/postgres', function(err, client, done) {
      if (err) {
        console.error("Failed to connect to db");
      }
      callback(err, client);
    });
  },
  function(err, client) {
    if (err) {
      return console.err("Giving up");
    }
    console.log("Connected to db");
    getVotes(client);
  }
);

function getVotes(client) {
  var allVotes = [];
  client.query('SELECT id, vote, ts FROM votes', [], function(err, result) {
    if (err) {
      console.error("Error performing query: " + err);
    } else {
      allVotes = result.rows.reduce(function(obj, row) {
        obj.push( {'id':row.id, 'vote':row.vote, 'ts':row.ts} );
	return obj;
      }, []);
    }
  });

  client.query('SELECT vote, COUNT(id) AS count FROM votes GROUP BY vote', [], function(err, result) {
    if (err) {
      console.error("Error performing query: " + err);
    } else {
      var data = result.rows.reduce(function(obj, row) {
        obj[row.vote] = row.count;
        return obj;
      }, {});
      data['allVotesArr'] = allVotes;
      io.sockets.emit("scores", JSON.stringify(data));
    }

    setTimeout(function() {getVotes(client) }, 1000);
  });
}

app.use(cookieParser());
app.use(bodyParser());
app.use(methodOverride('X-HTTP-Method-Override'));
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.header("Access-Control-Allow-Methods", "PUT, GET, POST, DELETE, OPTIONS");
  next();
});

app.use(express.static(__dirname + '/views'));

app.get('/', function (req, res) {
  res.sendFile(path.resolve(__dirname + '/views/index.html'));
});

server.listen(port, function () {
  var port = server.address().port;
  console.log('App running on port ' + port);
});
