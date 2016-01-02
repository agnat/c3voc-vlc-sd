var http = require('http');

var server = http.createServer(function (request, response) {
  console.log(request.url);
  if (request.url == "/events/v1.json") {
    response.writeHead(200, {"Content-Type": "text/plain"});
    response.end(JSON.stringify(
    [ { "name": "32nd Chaos Communication Congress – Gated Communities"
      , "slug": "32c3"
      , "state": "running"
      }
    , { "name": "33nd Chaos Communication Congress – [Ba]king [Br]ead"
      , "slug": "33c3"
      , "state": "upcoming"
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
      { "hall1":
        { "name": "Hall 1: High Performance Firtzbox! Clusters"
        , "translation": true
        , "url": "https://cdn.c3voc.de/hls/s1_native_hd.m3u8"
        }
      , "hall2":
        { "name": "Hall 2: Cyber-Außenpolitik"
        , "translation": true
        , "url": "https://cdn.c3voc.de/hls/s2_native_hd.m3u8"
        }
      , "hall6":
        { "name": "Hall 6: From Nerdistan to Userland – A Travelreport"
        , "translation": true
        , "url": "https://cdn.c3voc.de/hls/s3_native_hd.m3u8"
        }
      , "hallg":
        { "name": "Hall G: XXX"
        , "translation": true
        , "url": "https://cdn.c3voc.de/hls/s4_native_hd.m3u8"
        }
      , "lounge":
        { "name": "Lounge"
        , "translation": false
        , "url": "https://cdn.c3voc.de/lounge.mp3"
        }
      , "ambient":
        { "name": "Ambient"
        , "translation": false
        , "url": "https://cdn.c3voc.de/ambient.mp3"
        }
      , "dome":
        { "name": "Dome"
        , "translation": false
        , "url": "https://cdn.c3voc.de/dome.mp3"
        }
      , "sendezentrum":
        { "name": "Sendezentrum"
        , "translation": false
        , "url": "https://cdn.c3voc.de/hls/s5_native_hd.m3u8"
        }
      , "podcastertisch":
        { "name": "Sendezentrum - Podcastertisch"
        , "translation": false
        , "url": "https://cdn.c3voc.de/hls/s6_native.mp3"
        }
      }
    }));
  } else {
    response.writeHead(404);
    response.end();
  }
});

server.listen(1337);
