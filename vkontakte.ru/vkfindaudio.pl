#!/usr/bin/perl
use LWP::UserAgent;
use HTTP::Cookies;

# ~/.config/secret ← file with auth info for various shit
# Looks like this:
# %logininfo = (
#	vk_login => 'vpupkin@example.com',
#	vk_passw => 'mycoolpassword'
# );

do "$ENV{HOME}/.config/secret";

my $browser = LWP::UserAgent->new();
$browser->cookie_jar(HTTP::Cookies->new());

# Login first
my $response = $browser->post("http://vk.com/login.php", {success_url => '', fail_url => '', try_to_login => 1, email => $logininfo{vk_login}, pass => $logininfo{vk_passw}});

my $query = join ' ', @ARGV;
$response = $browser->get("http://vk.com/gsearch.php?q=$query&section=audio");
if ($response->is_success) {
	foreach (split /\n/, $response->content) {
		print "http://cs$1.vk.com\/u$2/audio/$3.mp3\n" if /return operate\([0-9]*,([0-9]*),([0-9]*),'([0-9a-f]*)',[0-9]*\)/;
	}
}
else {
	die "HTTP Request failed";
}
