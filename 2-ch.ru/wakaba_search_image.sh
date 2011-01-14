#!/bin/bash 

if [ -z "$1" ]; then
    echo "usage: $0 <img_url> [last_page]"
    exit 1
fi
HOST=`awk -F/ '{print $3}' <<< "$1"`
BOARD=`awk -F/ '{print $4}' <<< "$1"`
IMAGE=`basename "$1"`
if [ "$2" ]; then
    PAGES=`eval echo {0.."$2"}`
else
    PAGES="0 1 2 3"
fi

for page in $PAGES; do
    url="http://$HOST/$BOARD/"
    if [ "$page" -ne "0" ]; then url="$url$page.html"; fi
    echo "Extracting threads from $url..."
    threads=`curl -s "$url" | \
             sed 's@<hr />@\n@g' | \
             sed -n "s@.*\[<a href=\"\([^\"]\+\)\">Ответ</a>\].*@http://$HOST\1@p"`
    echo "Searching image..."
    for thread in $threads; do
        if [ "`curl -s \"$thread\" | fgrep -o \"$IMAGE\"`" ]; then
            echo "*** Found in $thread"
            exit
        fi
    done
done
