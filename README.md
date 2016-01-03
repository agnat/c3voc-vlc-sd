### VLC service discovery of C3VOC event streams

![VLC Screenshot](doc/images/vlc_c3voc_service_discovery.png)

#### Installation

Unfortunately VLC does not execute service discovery scripts in your home directory. You've got to plomp the script into a system/application folder:

 * Mac OS X: `cp lua/sd/c3voc.lua /Applications/VLC.app/Contents/MacOS/share/lua/sd/`
 * Linux: `cp lua/sd/c3voc.lua /usr/share/vlc/lua/sd`

Note: Currently the script renders _static demo content_. To play with an actual voc/streaming-website adjust the `streams_url` variable in `lua/sd/c3voc.lua`.

