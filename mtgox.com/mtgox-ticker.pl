#!/usr/bin/perl
use LWP::Simple;
use JSON;
my %resp = %{from_json(get("https://mtgox.com/api/1/BTCUSD/ticker"))};
print "Sell:  $resp{return}{sell}{value}\n";
print "Buy:  $resp{return}{buy}{value}\n";
