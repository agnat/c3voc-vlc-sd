### VLC service discovery of C3VOC event streams

C3VOC provides live streaming of [Chaos Computer Club](https://www.ccc.de/en/) events and [other OSS related conferences](https://streaming.media.ccc.de). This script implements automatic service discovery of these streams in the [VLC media player](http://www.videolan.org/vlc/index.html).

![VLC Screenshot Mac](doc/images/vlc_c3voc_sd_macosx.png)

... or [on Ubuntu](https://raw.githubusercontent.com/agnat/c3voc-vlc-sd/master/doc/images/vlc_c3voc_sd_ubuntu.png)

#### Installation

Get a terminal and download the script by running

````bash
curl -O https://raw.githubusercontent.com/agnat/c3voc-vlc-sd/master/lua/sd/c3voc.lua
````

##### Linux

````
mkdir -p ~/.local/share/vlc/lua/sd
mv c3voc.lua ~/.local/share/vlc/lua/sd
````

##### Mac OS

````
mkdir -p ~/Library/Application\ Support/org.videolan.vlc/lua/sd/
mv c3voc.lua ~/Library/Application\ Support/org.videolan.vlc/lua/sd/
````

##### Windows

Download the script by any means necessary. Then move it to `%APPDATA%\vlc\lua\sd` ... I think.

#### Kown Issues

VLC service discovery scripts are not truely dynamic. They only fetch content once on first view. On Mac OS I found a trick to re-trigger the script.

1. Deselect the "C3VOC Streaming" entry in the sidebar. (Select "Podcasts" or something)
1. Right-click on "C3VOC Streaming" and disable it.
1. Select "C3VOC Streaming" again. This re-enables the script and triggers a reload.

#### Unkown Issues

Fork and fix or file an issue.
