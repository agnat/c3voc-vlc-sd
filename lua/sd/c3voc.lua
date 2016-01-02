--[[
--]]

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

local lazily_loaded = false

local dkjson = nil
local json = {}
json["parse_url"] = function(url)
  vlc.msg.info("Fetching " .. url)
  local stream = vlc.stream(url)
  local string = ""
  local line   = ""

  repeat
    line = stream:readline()
    string = string..line
  until line ~= nil

  return dkjson.decode(string)
end

function lazy_load()
  if lazily_loaded then return nil end
  dkjson = require "dkjson"
  lazily_loaded = true
end

function descriptor()
  return { title = sidebar_title }
end

function dropnil(s)
  if s == nil then return "" else return s end
end

function add_group_members(parent, members, streams)
  for _,member in ipairs(members) do
  vlc.msg.info("member " .. member)    
    local room = streams["rooms"][member];
    parent:add_subnode({title = room["name"]});
  end
end

function add_streams(parent, slug)
  local streams = json.parse_url(streams_url(slug))
  for group,members in pairs(streams["groups"]) do
    local group_node = parent:add_subnode({title = group});
    add_group_members(group_node, members, streams)
  end
end

function add_stream(parent, stream)
  parent:add_subitem(
    { path = "https://"
    , title = stream["name"]
      --"url" = 
      --"language" = 
      --"nowplaying" = 
      --"publisher" = 
      --"encodedby" = 
      --"arturl" = 
      --"options" = 
      --"meta" = 
    })
end

function event_is_in_progress(event)
  return true
end

function main()
  lazy_load()

  local events = json.parse_url(events_url())

  for _,event in ipairs(events) do
    local parent = vlc.sd.add_node({ title = event["name"] })
    if (event_is_in_progress(event)) then
      add_streams(parent, event["slug"])
    end
  end

--[[
  local tree = simplexml.parse_url("http://dir.xiph.org/yp.xml")
  for _, station in ipairs( tree.children ) do
    simplexml.add_name_maps( station )
    local station_name = station.children_map["server_name"][1].children[1]
    if station_name == "Unspecified name" or station_name == "" or station_name == nil
    then
      station_name = station.children_map["listen_url"][1].children[1]
      if string.find( station_name, "radionomy.com" )
      then
        station_name = string.match( station_name, "([^/]+)$")
        station_name = string.gsub( station_name, "-", " " )
      end
    end
    vlc.sd.add_item( {path=station.children_map["listen_url"][1].children[1],
                      title=station_name,
                      genre=dropnil(station.children_map["genre"][1].children[1]),
                      nowplaying=dropnil(station.children_map["current_song"][1].children[1]),
                      uiddata=station.children_map["listen_url"][1].children[1]
                              .. dropnil(station.children_map["server_name"][1].children[1]),
                      meta={["Listing Source"]="dir.xiph.org",
                            ["Listing Type"]="radio",
                            ["Icecast Bitrate"]=dropnil(station.children_map["bitrate"][1].children[1]),
                            ["Icecast Server Type"]=dropnil(station.children_map["server_type"][1].children[1])
                          }} )
  end
  --]]
end
