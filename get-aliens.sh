#!/bin/sh
get () {
	wget "$1" -O "$2"
}

mkdir -p omploader.org
cd omploader.org
get http://omploader.org/ompload ompload
chmod +x ompload
cd ..
