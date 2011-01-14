#!/usr/bin/env python
# -*- coding: utf-8 -*-
import urllib, sys
whole_thread = urllib.urlopen(sys.argv[1])
whole_thread = whole_thread.read().replace(" ","")

parse0 = whole_thread.split("<hr/>")
parse = parse0[2][parse0[2].rfind("reflink"):]
parse = parse[:parse.find("</a>")]
parse = parse[parse.rfind(">")+1:]

# if sage
for i in xrange(3,len(parse0)):
    parse2 = parse0[i][parse0[i].rfind("reflink"):]
    parse2 = parse2[:parse2.find("</a>")]
    parse2 = parse2[parse2.rfind(">")+1:]
    if parse2 > parse:
        parse = parse2
    
print parse.replace("&#x2116;", "№")
