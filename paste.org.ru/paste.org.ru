#!/bin/bash
c=`cat $1`
c=${c//%/%25}
c=${c//&/%26}
c=${c//=/%3d}
c=${c//+/%2b}
c="code=$c"

r=`(echo "POST / HTTP/1.0
Host: paste.org.ru
Cookie: name=w3crapcli
Content-length: ${#c}

$c";)|netcat paste.org.ru 80`
r=${r#*href=\"}
echo "http://paste.org.ru${r%%\">*}"

