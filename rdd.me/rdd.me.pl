#!/usr/bin/perl -w

#  Copyright (c) 2013, Alexander Batischev
#  All rights reserved.

use strict;
use warnings;

use v5.010; # 'say' is way neater than 'print ..., "\n"'

use Getopt::Long;
use HTTP::Lite;
use JSON;



my $url = '';
my $help = 0;
my $epub = 0;
GetOptions(
  'help'  => \$help
, 'url=s' => \$url
, 'epub'  => \$epub
) or die "Error in command line arguments\n";
# URL is required unless --help option is specified
$url = $ARGV[0] unless $help;

show_help() if ( $help or ! $url );
my $rdd_id = get_rdd_id($url);
if ( $epub ) {
  say "http://www.readability.com/articles/$rdd_id/download/epub/";
} else {
  say "http://rdd.me/$rdd_id";
}



sub show_help {
  say "$0 [-h|--help]";
  say "$0 [--epub] URL";
  say "";
  say "Prints out shortened URL. If --epub is specified, ePub download URL";
  say "is shown instead.";

  exit 1;
}



sub get_rdd_id {
  my $http = HTTP::Lite->new();

  # Readability Shortener API can be found at
  # http://www.readability.com/developers/api/shortener
  $http->prepare_post( {
    'url' => $url
  } );
  $http->add_req_header('Content-Type', 'application/x-www-form-urlencoded');

  my $request =
    $http->request("http://www.readability.com/api/shortener/v1/urls")
    or die "Unable to POST document: $!";

  my $deserialized = from_json( $http->body() );
  return $deserialized->{'meta'}->{'id'};
}

