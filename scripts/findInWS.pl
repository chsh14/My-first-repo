#!/usr/bin/perl -w  
use strict;
use warnings;
use Data::Dumper qw(Dumper);
use File::Find::Rule;

#my $pathToSearch = $ENV{VC_WORKSPACE}/products/LodeRunner/LodeRunner/common
#chdir(/Users\/chirayushah");
my $pathToSearch = "/Users/chirayushah";
my $inputDir = $ARGV[0];
my $insideDir = $ARGV[1]; 
if (not defined $inputDir ) {
    die "I need some name to search";
}
#print "Dir 1: $inputDir, Dir 2  $insideDir"; 
#print "You want to search $inputDir "; 
my $rule = File::Find::Rule->new;
$rule->directory;
$rule->name( "*$inputDir*" );
$rule->maxdepth( 1 );
my @dir = $rule->in( $pathToSearch );
#print "Dir Parent: $dir[0]";
foreach my $n (@dir) {
#    print "$n \n";
#    #chdir($n) or die "$!";
}
my $rule2 =  File::Find::Rule->new; 
$rule2->directory; 
$rule2->name( "*$insideDir*" );
$rule2->maxdepth( 1 ); 
my @insidedir = $rule2->in($dir[0]);
foreach my $n (@insidedir) {
    print "$n";
    #chdir($n) or die "$!";
} 

