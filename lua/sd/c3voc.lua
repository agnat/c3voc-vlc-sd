local sidebar_title = "C3VOC Streaming"
local base_url      = "http://localhost:1337" -- "https://streaming.events.ccc.de"
local events_path   = "events/v1.json"
local streams_path  = "streams/v1.json"

function events_url()
  return base_url .. "/" .. events_path
end

function streams_url(event_slug)
  return base_url .. "/" .. event_slug .. "/" .. streams_path
end

-- See vlc/share/lua/sd/README.txt
local lazily_loaded = false

local dkjson = nil
local common = nil
local json =
{ parse_url = function(url)
    vlc.msg.info("Fetching " .. url)
    local stream = vlc.stream(url)
    local string = ""
    local line   = ""

    repeat
      line = stream:readline()
      string = string .. line
    until line ~= nil

    return dkjson.decode(string)
  end
}

function lazy_load()
  if lazily_loaded then return nil end
  dkjson = require "dkjson"
  common = require "common"
  lazily_loaded = true
end

function dropnil(s)
  if s == nil then return "" else return s end
end

function add_stream(parent, title, url)
  parent:add_subitem({ title = title
                     , path = url
                     });
end

function add_translations(parent, room)
  add_stream(parent, "Native", room["url"]);
  add_stream(parent, "Live Translation", room["url"]);
end

function add_rooms(parent, members, streams)
  for _,member in ipairs(members) do
    local room = streams["rooms"][member];
    local room_name = room["name"];
    if room["translation"] then
      local room_node = parent:add_subnode({title = room_name});
      add_translations(room_node, room)
    else
      add_stream(parent, room_name, room["url"]);
    end
  end
end

function add_groups(parent, slug)
  local streams = json.parse_url(streams_url(slug))
  for group,members in common.pairs_sorted(streams["groups"]) do
    local group_node = parent:add_subnode({title = group});
    add_rooms(group_node, members, streams)
  end
end

function event_is_in_progress(event)
  return true
end

-- Service Discovery API Functions

function descriptor()
  return { title = sidebar_title
         , capabilities = {}
         }
end

function main()
  lazy_load()

  local events = json.parse_url(events_url())

  for _,event in ipairs(events) do
    local parent = vlc.sd.add_node({ title = event["name"] })
    if (event_is_in_progress(event)) then
      add_groups(parent, event["slug"])
    end
  end
end
