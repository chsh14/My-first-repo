#!/usr/bin/perl -w  
use lib '/pri/chsh/5.18/5.18';
use strict;
use warnings;
use Data::Dumper qw(Dumper);
use File::Find::Rule;

#my $pathToSearch = $ENV{VC_WORKSPACE}/products/LodeRunner/LodeRunner/common
#chdir(/Users\/chirayushah");
my $pathToSearch = $ARGV[0];
my $inputDir = $ARGV[1];
my $insideDir = $ARGV[2]; 
my $levels = $ARGV[3];
#print "Dir 1: $inputDir, Dir 2  $insideDir"; 
#print "You want to search $inputDir "; 
my @dir ;
if (defined $inputDir ) { 
    my $rule = File::Find::Rule->new;
    $rule->directory;
	$rule->extras({ follow => 1 });
	my $lastword = substr $inputDir,-1;
	#print $lastword;
	if ($lastword eq "/" ) { #look for '/' in the end of the string to make exact search
		$inputDir =~ s/\///g;
		#print "This  $inputDir\n";
		$rule->name("*$inputDir");
	}
	else {
		$rule->name( "*$inputDir*" );
	}
	$rule->maxdepth( 1 );
	@dir = $rule->in( $pathToSearch );
	#print "Dir Parent: $dir[0]";
	#foreach my $n (@dir) {
	if (not defined $insideDir ) {
		print "$dir[0]";
	}
	
        #}
}
else {
    print "$pathToSearch";
}
if (defined $insideDir ) { 
    my $rule2 =  File::Find::Rule->new; 
    $rule2->directory; 	
	$rule2->extras({ follow => 1 });
    $rule2->name( "*$insideDir*" );
    if (defined $levels ) { 
        $rule2->maxdepth( "$levels" ); 
    }
    else {
        $rule2->maxdepth( 1 );
    }
    my @insidedir = $rule2->in($dir[0]);
    #foreach my $n (@insidedir) {
        print "$insidedir[0]";
        #break;
        #chdir($n) or die "$!";
        #}
}


