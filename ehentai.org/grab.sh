#!/bin/bash

[ ! "$1" ] && { echo "USAGE: $0 <gallery url>"; exit; };

url="$1"

content=1;

echo "$url" | grep -q "g.e-hentai.org" && { content=0; };

echo "Downloading for $url";
if [ "$content" -eq 1 ]; then
   
  pages="$(wget -q -w1 -U 42 -O- "$url" | sed -n '/<div style="text-align:center">/{s|||g;s|<a class="[^"]*" href="[^"]*" style="font-size:10pt" rel="nofollow">\([0-9]*\)</a>&nbsp;|\1 |g;s|</div>||g;p;q}')";
  pages=${pages:-1};
   
  list="$(
  for page in $pages; do
      wget -q -w1 -O- "$url/$page" | sed -n '/<tr><td style="text-align:center; vertical-align:bottom">/{s|<td style="text-align:center; vertical-align:bottom"><a href="\([^"]*\)" rel="nofollow"><img src="[^"]*" alt="[0-9]*" style="border:1px solid #606060; margin:1px 5px 1px 5px; padding:0" /><br />[0-9]*</a></td>|\1\n|g;s,<\(/\|\)tr>,,g;p}';
    done | sed '/^$/d'
  )";
  link="$(echo "$list" | head -n1)"
  wget -q --keep-session-cookies --save-cookies=/tmp/e-hentai-cook --spider "$link" ;
   
   
  length="$(echo "$list" | wc -l)";
  i=1;
  echo "$list" | while read line; do 
   wget -q -w1 -O- "$line" | sed -n '/<a id="next_img"/{s|<a id="next_img" href="[^"]*" onclick=""><img id="image_display" src="\([^"]*\)" border="0" title="[^"]*" alt="[^"]*" style="[^"]*" /></a>|\1|g;p}' 
  done | while read link; do
   frm="$(printf "%0${#length}d" "$i")";
   echo "  downloading image ($frm/$length)";
   wget -q -U 42 --load-cookies=/tmp/e-hentai-cook -O "${frm}.jpg" "$link";
   i=$(($i+1));  
  done
else
  pages="$(wget -q -w1 -U 42 -O- "$url" | sed -n '/Showing/{s|<td class="[^"]*"[^>]*><a class="[^"]*" href="[^"]*" onclick="[^"]*">\([0-9]*\)</a></td>|\1 |g;s|<td class="ptd ptdt" onclick="document.location.*||g;s/.*>//g;p}')";
  pages=${pages:-1};
  
  list="$(
    for page in $pages; do
      let page--;
      wget -q -w1 -U 42 -w1 -O- "$url/1-m-y/$page" | sed -n '/^<a class="noul" href="\([^"]*\)".*/{s//\1/g;p}';
    done;
  )";
 
  length="$(echo "$list" | wc -l)";

  i=1;
  
  echo "$list" | while read line; do 
    wget -q -w1 -O- "$line" | sed -n '/.*<img id="[^"]*" src="\([^"]*\)".*/{s//\1/;p}' 
  done | while read link; do
    frm="$(printf "%0${#length}d" "$i")";
    echo "  downloading image ($frm/$length)";
    wget -q -U 42 -w1 --load-cookies=/tmp/e-hentai-cook -O "${frm}.jpg" "$link";
    i=$(($i+1));  
  done;
  
fi;


echo "Downloading for $url finished";
rm /tmp/e-hentai-cook;
