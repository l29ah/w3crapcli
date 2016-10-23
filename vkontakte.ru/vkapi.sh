#!/bin/bash
auth() {
	atf=~/.config/vkbash/access_token
	if [ ! -e "$atf" ]; then
		echo "Usage: go to <http://oauth.vk.com/authorize?client_id=2740767&scope=offline,audio,wall,photos&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token> and copy the access_token from url to $atf" >&2
		exit 1
	fi
	export at=$(cat "$atf")
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
