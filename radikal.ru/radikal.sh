#!/bin/sh

if [ "$1" = "-u" ]; then
	file=""
	urlf="$2"
else
	file="@$1"
	urlf=""
fi

data=`curl -F upload=yes \
           -F F="$file"  \
           -F URLF=$urlf \
           -F Submit=""  \
           http://www.radikal.ru/action.aspx`
echo "$data" | grep -E 'http://[a-z0-9]*\.radikal\.ru/[^\["]*[^x]\.(jpg|jpeg|png|gif)' -o | head -1
