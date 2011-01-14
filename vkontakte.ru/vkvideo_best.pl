#!/usr/bin/perl
use LWP::Simple;

$_ = get($ARGV[0]);
/host=(.*?)&/;
$host=$1;
/uid=(.*?)&/;
$uid=$1;
/vtag=(.*?)&/;
$vtag=$1;

foreach $res (240, 360, 525, 720) {
	$url = "${host}u$uid/video/$vtag.$res.mp4";
	$succ_url = $url if head($url);
}

print $succ_url
