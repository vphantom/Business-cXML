#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Business::cXML' ) || print "Bail out!\n";
}

diag( "Testing Business::cXML $Business::cXML::VERSION, Perl $], $^X" );
