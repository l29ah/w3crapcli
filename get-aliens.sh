#!/bin/sh
get () {
	wget "$1" -O "$2"
}

mkdir -p omploader.org
cd omploader.org
get http://omploader.org/ompload ompload
chmod +x ompload
cd ..

#emerge youtube-dl

#emerge get_flash_videos

#emerge youtube-viewer

cd last.fm
get "http://www.update.uu.se/~zrajm/programs/mplayer-lastfm/`http://www.update.uu.se/~zrajm/programs/mplayer-lastfm/ | sed -ne 's#.*\(mplayer-lastfm-[^<]*\)<.*#\1#p' | tail -n1`" mplayer-lastfm
chmod +x mplayer-lastfm
cd ..
