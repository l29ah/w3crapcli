#!/usr/bin/perl
use LWP::Simple;

$_ = get($ARGV[0]);
/host=(.*?)&/;
$host=$1;
/uid=(.*?)&/;
$uid=$1;
/vtag=(.*?)&/;
$vtag=$1;

# I dunno where 240 came from, assume some magic const
print "${host}u$uid/video/$vtag.240.mp4\n";
