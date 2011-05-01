#!/bin/bash

USERNAME=$1
API_KEY=b25b959554ed76058ac220b7b2e0a026

get_counter_value()
{
    curl -s "http://ws.audioscrobbler.com/2.0/?method=user.getinfo&user=${USERNAME}&api_key=${API_KEY}" |\
    grep -E "^\ +<playcount>.*</playcount>$" |\
    sed -r -e 's/<(\/)?playcount>//g' -e 's/^(\ )+(.*)*$/\2/g'
}

songs=`curl -s "http://ws.audioscrobbler.com/1.0/user/${USERNAME}/recenttracks.rss" |\
grep -E "^\ +<title>.*</title>$" |\
sed -r -e 's/<(\/)?title>//g' -e 's/^(\ )+(.*)*$/\2/g'`

last_song=`echo "$songs" | head -n 1`

if [[ "$#" -eq 1 ]]; then
    echo "$last_song"
    exit
fi 

case "$2" in
    -t) #last song or now playing
        echo "$last_song"
        exit
    ;;
    -a) #last 10 songs
        echo "$songs"
        exit
    ;;
    -c) #counter
        get_counter_value
        exit
    ;;
esac
