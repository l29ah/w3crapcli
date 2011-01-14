#!/bin/bash

[ ! "$1" ] && { echo "USAGE: $0 <Artist> - <Album Name>"; exit; };

urlencode() {
(
  IFS="";
  cat | od -t x1 -v | 
    sed 's/^[0-9]*//g;s/[[:space:]]\{1,\}/%/g;s/[%]*$//g;' | 
    while read -r line; do 
      printf "%s" "${line}"; 
    done;
  return 0;
)
};

sstring="$@";
url="http://www.allcdcovers.com/search/all/all/$(echo "$sstring" | urlencode)/1";

links="$(wget -O- "$url" | sed -n '/<td class="expander">/{s/.*//g;N;s|<a href="\([^"]*\)">[^<]*</a>|http://www.allcdcovers.com\1 |g;s,\(<[/]*td>\||\),,g;p}')";

for link in $links; do
  wget -O- "$link" | sed -n '/download.gif/{s|.*href="\(/download/[^"]*\)".*|http://www.allcdcovers.com\1|g;p}';
done | while read line; do
  wget -c "$line" -O "${line##*/}.jpg";
done;
