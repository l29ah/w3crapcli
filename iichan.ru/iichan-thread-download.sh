#!/bin/sh
[ ! "$1" ] && { echo "USAGE: $0 http://iichan.ru/b/res/1122334.html"; exit; }
url="$1";
board="$(echo "$url" | sed 's|^.*/\([^/]*\)/res/[0-9]*.*|\1|')";
wget -e robots=off -kpcr -I "/${board}/src" "$url";
