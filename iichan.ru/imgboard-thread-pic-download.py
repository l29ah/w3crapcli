#!/usr/bin/env python
from urllib import urlopen
from urlparse import urlparse
from sys import argv
from threading import Thread, enumerate, Lock
from time import sleep

def download(url, counter=0):
    print '[', ''.join([str(counter*100/content_list_len), '%']), \
        '] Downloading', rel_path, '...'
    dstfile = open(rel_path.split('/')[-1], 'wb')
    if rel_path.startswith("http://"):
        srcstream = urlopen(rel_path)
    else:
        srcstream = urlopen(''.join(["http://", boardurl.netloc, rel_path]))
    dstfile.write(srcstream.read())
 
boardurl = urlparse(argv[1])
thread_url = ''.join(['http://', boardurl.netloc, boardurl.path])
print 'Fetching images from', thread_url, '...',
contentfile = urlopen(thread_url)
print "Done."
content = contentfile.read().split('<div id="thread-',1)
if len(content) == 1:
    content = content[0]
else:
    content = ''.join(content[1:])
counter = 0
#nullchan_type = False
content_list = content.split('<a target="_blank" href="')
# if len(content_list) < 2:
#     content_list = content.split('javascript:expandimg')
#     nullchan_type = True
content_list_len = len(content_list)
for rel_path_raw in content_list:
    # if nullchan_type:
    #     rel_path = rel_path_raw.split("'")[3]
    # else:
    rel_path = rel_path_raw.split('"', 1)[0]
    counter += 1
    if rel_path.endswith('.jpg') or \
            rel_path.endswith('.jpeg') or \
            rel_path.endswith('.png') or \
            rel_path.endswith('.gif'):
        while len(enumerate()) > 4:
            sleep(1) 
        Thread(target=download, args=(rel_path, counter)).start()
