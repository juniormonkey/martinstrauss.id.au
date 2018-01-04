#!/usr/bin/perl
use CGI::Pretty qw(:standard);

system("./agent input output &") and do { die "urg."; };

print header;
print start_html(-title => 'blah');
print "Hello there!";
print end_html;
