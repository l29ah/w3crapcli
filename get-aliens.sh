#!/bin/sh
get () {
	wget "$1" -O "$2"
}

#emerge youtube-dl

#emerge get_flash_videos

#emerge youtube-viewer

cd last.fm
get "http://www.update.uu.se/~zrajm/programs/mplayer-lastfm/`http://www.update.uu.se/~zrajm/programs/mplayer-lastfm/ | sed -ne 's#.*\(mplayer-lastfm-[^<]*\)<.*#\1#p' | tail -n1`" mplayer-lastfm
chmod +x mplayer-lastfm
cd ..

cd dump.bitcheese.net
get 'https://gist.github.com/Voker57/221804/raw/dump.sh' dump.sh
chmod +x dump.sh
cd ..
