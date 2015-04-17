#!/bin/bash
auth() {
	fn=`tempfile -p vkbashcookies`
	trap 'rm "$fn";' EXIT
	umask 0077
	read login password
	wget --save-cookies "$fn" "https://login.vk.com/?act=login" --post-data "email=`printf %s "$login" | urlencode`&pass=`printf %s "$password" | urlencode`" -O /dev/null 2> /dev/null
	export at=$(wget --load-cookies "$fn" "http://oauth.vk.com/authorize?client_id=3082784&scope=audio&redirect_uri=http://oauth.vk.com/blank.html&display=wap&response_type=token" --post-data='submit=Разрешить' -O /dev/null 2>&1 | grep "access_token" | cut -d "=" -f2 | cut -d "&" -f1)
}

dbg() {
	true
	#echo "$@" 1>&2
}

api() {
	dbg ">>>> api request $1"
	resp="$(curl -sS -c "$fn" "https://api.vk.com/method/$1")"
	dbg "<<<< $(jq . <<< "$resp")"
	echo -n "$resp"
}
