var http = require('http');

var server = http.createServer(function (request, response) {
  console.log(request.url);
  if (request.url == "/events/v1.json") {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.end(JSON.stringify(
    [ { "name": "32nd Chaos Communication Congress - Gated Communities"
      , "slug": "32c3"
      }
    , { "name": "33nd Chaos Communication Congress - [Ba]king [Br]ead"
      , "slug": "33c3"
      }
    ]));
  } else if (request.url == "/32c3/streams/v1.json" || request.url == "/33c3/streams/v1.json") {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.end(JSON.stringify(
    { "groups":
      { "Lecture Rooms": ["hall1", "hall2", "hallg", "hall6"]
      , "Live Music": ["lounge", "ambient", "dome"]
      , "Live Podcasts": ["sendezentrum", "podcastertisch"]
      }
    , "rooms": 
      { "hall1": {"name": "Hall 1"}
      , "hall2": {"name": "Hall 2"}
      , "hall6": {"name": "Hall 6"}
      , "hallg": {"name": "Hall G"}
      , "lounge": {"name": "Lounge"}
      , "ambient": {"name": "Ambient"}
      , "dome": {"name": "Dome"}
      , "sendezentrum": {"name": "Sendezentrum"}
      , "podcastertisch": {"name": "Sendezentrum - Podcastertisch"}
      }
    }));
  } else {
    response.writeHead(404);
    response.end();
  }
});

server.listen(1337);
