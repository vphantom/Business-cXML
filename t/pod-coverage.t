#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

use Pod::Coverage::CountParents;

unless ( $ENV{RELEASE_TESTING} ) {
    plan( skip_all => "Author tests not required for installation" );
}

# Ensure a recent version of Test::Pod::Coverage
my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
    if $@;

all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::CountParents' });
