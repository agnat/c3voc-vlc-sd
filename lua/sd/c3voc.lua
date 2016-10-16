local sidebar_title = "C3VOC Streaming"
local base_url      = "https://streaming.media.ccc.de"
local streams_path  = "streams/v1.json"

local streams_url = base_url .. "/" .. streams_path
-- streams_url = "https://gist.githubusercontent.com/MaZderMind/d5737ab867ade7888cb4/raw/bb02a27ca758e1ca3de96b1bf3f811541436ab9d/streams-v1.json"

-- See vlc/share/lua/sd/README.txt
local lazily_loaded = false

local dkjson = nil
local common = nil
local json =
{ parse_url = function(url)
    --vlc.msg.info("Fetching " .. url)
    local stream = vlc.stream(url)
    local string = ""
    local line   = ""

    repeat
      line = stream:readline()
      if line then string = string .. line end
    until line == nil

    return dkjson.decode(string)
  end
}

function lazy_load()
  if lazily_loaded then return nil end
  dkjson = require "dkjson"
  common = require "common"
  lazily_loaded = true
end

function add_urls(parent, urls)
  for _,url in pairs(urls) do
    parent:add_subitem({ title = url["display"], path = url["url"]})
  end
end

function add_streams(parent, streams)
  if #streams == 1 then
    add_urls(parent, streams[1]["urls"])
  else
    for _,stream in pairs(streams) do
      local stream_node = parent:add_subnode({title = stream["display"]})
      add_urls(stream_node, stream["urls"])
    end
  end
end

function add_rooms(parent, group)
  local rooms = group["rooms"]
  for _,room in pairs(rooms) do
    local room_node = parent:add_subnode({title = room["display"]})
    local streams = room["streams"]
    add_streams(room_node, streams)
  end
end

function add_groups(parent, groups)
  for name,group in common.pairs_sorted(groups) do
    group_node = parent:add_subnode({title = name})
    add_rooms(group_node, group)
  end
end

-- Service Discovery API Functions

function descriptor()
  return { title = sidebar_title
         , capabilities = {}
         }
end

function main()
  lazy_load()

  local streams_json = json.parse_url(streams_url)

  local conferences = {}
  for _,group in ipairs(streams_json) do
    local conference = group["conference"]
    if conferences[conference] == nil then
      conferences[conference] = {}
    end
    local group_name = group["group"]
    conferences[conference][group_name] = group
  end
  if next(conferences) == nil then
    vlc.sd.add_node({title = "Upcoming Events: " .. base_url})
  else
    for name,conference in pairs(conferences) do
      local conference_node = vlc.sd.add_node({title = name})
      add_groups(conference_node, conference)
    end
  end
end
