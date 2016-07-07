#!/usr/bin/perl -w  
use lib '/pri/chsh/5.18/5.18';
use strict;
use warnings;
use Data::Dumper qw(Dumper);
use Text::Extract::Word;
use File::Find::Rule;
use autodie; # Replace functions with ones that succeed or die with lexical scope (Not applies to print function)
use warnings FATAL => 'all',NONFATAL => 'syntax'; # will exit the code on any warning except syntax warnings.
binmode STDOUT, ':encoding(UTF-8)';


sub findfiles {
	
	
}

sub processfiles {
	my $numberfiles = scalar(@_);
	print "Number of input *.doc files are $numberfiles";
	my @wordList = @_; # default array variable
	printCust(@wordList);
	
}

sub printCust {
	print "---------------------------\n";
	print "\"$_[0]\"\n";
	print "---------------------------\n";	
}