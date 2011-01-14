#!/bin/sh
[ ! "$1" ] && { echo "USAGE: $0 http://iichan.ru/b/res/1122334.html"; exit; }
url="$1";
wget -e robots=off -kpcr -I "*/src" "$url";
