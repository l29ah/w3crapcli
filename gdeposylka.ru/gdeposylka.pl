#!/usr/bin/perl
use strict;
use warnings;
use encoding 'utf8';
use feature 'switch';
use JSON;
use LWP::Simple;
use URI::Escape;

my $apikey = "PUT_NUMBERS_FROM_YOUR_ACCOUNT_HERE";

sub request {
	my ($method, %args) = @_;
	$args{'apikey'} = $apikey;
	my ($k, @a);
	foreach $k (keys %args) {
		push @a, "$k=" . uri_escape($args{$k});
	}
	my $resp = get("http://ws.gdeposylka.ru/x1/$method/json?".join("&", @a)) or die;
	return %{from_json($resp, {"utf8" => "1"})} or die;
}

my (%data, $k, %v);
given ($ARGV[0]) {
	# TODO: add, detailed track info (anybody need this shit anyway?)
	default {
		%data = request("tracks.list", "area" => "main" );
		%data = %{$data{tracks}};
		foreach $k (keys %data) {
			%v = %{$data{$k}};
			print "$k ($v{description})\n";
			print "\t" . localtime($v{last_date}) . ": $v{message}\n";
		}
	}
};
