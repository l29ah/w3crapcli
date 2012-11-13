#!/usr/bin/perl

# ~/.config/lastfm looks like this:
# $login = 'vpupkin';
# $password = 'mycoolpassword';

$hs_url = "http://post.audioscrobbler.com/";
$client_id = "lsd";
$client_version = "1.0.4";
$debug = 1;


use LWP::UserAgent;
use Digest::MD5 qw(md5_hex);
use URI::Escape;

die "Usage: lastfm.pl <artist> <title> <album> <length>" unless $#ARGV==3;
$ua = LWP::UserAgent->new;

do "$ENV{HOME}/.config/lastfm";

foreach ("login", "password") {
	die "No $_ in ~/.config/lastfm" unless ${$_};
}

my $resp = $ua->get($hs_url."?hs=true&p=1.1&c=$client_id&v=$client_version&u=$login");
die "Unable to handshake with $hs_url" unless $resp->is_success;
($status, $token, $url, $int) = split(/\n/, $resp->content, 4);
print "Status: $status\nHash: $hash\nUrl: $url\n$int" if $debug;
die "Handshake failed, server returned: $status=\n" unless $status =~ /UP(TO)?DATE/;

$hash = md5_hex(md5_hex($password).$token);
@t = gmtime();
$req_str = "u=$login&s=$hash&a[0]=".uri_escape($ARGV[0]).'&t[0]='.uri_escape($ARGV[1]).'&b[0]='.uri_escape($ARGV[2]).'&m[0]=&l[0]='.uri_escape($ARGV[3]).'&i[0]='.uri_escape(sprintf('%04d-%02d-%02d %02d:%02d:%02d', $t[5] + 1900, $t[4] + 1, @t[3, 2, 1, 0]));

print "$req_str\n" if $debug;

my $req = HTTP::Request->new(POST=>$url);
$req->content_type('application/x-www-form-urlencoded');
$req->content($req_str);
$resp = $ua->request($req);

($status, $int) = split(/\n/, $resp->content, 2);
print "Server returned: $status\n" if $debug;
die "Scrobble failed, server returned: $status\n" unless $status == "OK";

