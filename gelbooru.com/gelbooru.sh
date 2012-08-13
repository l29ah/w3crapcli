#!/bin/bash
# Gelbooru parser
# Download pictures from http://gelbooru.com by tags
# Usage: ./gelbooru.sh [tags] [folder for pictures (will create if unset)]
# Depends: bash, wget, xmlstarlet, GNU parallel
# License: Public Domain, http://creativecommons.org/publicdomain/mark/1.0/

# Check for parameters
if [[ ! $1 || "$1" == "-h" || "$1" == "--help" ]]; then
	echo -e "Gelbooru parser\nDownload pictures from http://gelbooru.com by tags\nUsage: ./gelbooru.sh [tags] [folder for pictures (will create if there is no)]"
	exit
fi
# Is wget installed?
if [[ ! $(wget -V) ]]; then
	echo "This script requires wget. Please, read manual for your distro and install it."
	exit
fi
# Is xmlstarlet installed?
if [[ ! $(xmlstarlet --version) ]]; then
	echo "This script requires xmlstarlet. Please, read manual for your distro and install it."
	exit
fi
folder="$2"
if [[ ! -d "$folder" ]]; then
	mkdir "$folder"
fi
cd "$folder"
pagecount="0"
tags=$(echo "$1" | sed -e 's/ /%20/g')
count=$(wget -q -O - "http://gelbooru.com/index.php?page=dapi&s=post&q=index&limit=0&tags=$tags" | xmlstarlet sel -t -v /posts/@count[1])
echo "Files in query \"$1\": $count"
while [ "$count" -ge "0" ] ; do
	wget -q -O - "http://gelbooru.com/index.php?page=dapi&s=post&q=index&limit=100&pid=$pagecount&tags=$tags" | xmlstarlet sel -t -m /posts/post/@file_url -v "." -n | parallel --eta -j 20 wget -nc "{}"
	let count=count-100
	let pagecount++
done
