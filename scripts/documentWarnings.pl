#!/usr/local/bin/perl 
#use warnings;
use Data::Dumper qw(Dumper);
my $JiraTable = "JiraTableToPaste.txt"; 
###########################
# Custom Print Function
###########################  
sub printCust {
    print "-----------------\n";
    print "$_[0]\n";
    print "------------------\n";
}   

sub UsageScript {
    my $message = <<"END_MESSAGE";
    Script takes one argument but multiple files can be given (see below)..
    Usage :         
          Example 1 : $0 "<log1> [log2]".. 
          Example 2 : $0 *.log
END_MESSAGE
    printCust "$message";
}

sub scriptInfo {
    my $message = <<"END_MESSAGE";
Hi There $ENV{'USER'}!
    This script creates JIRA Table in $JiraTable, which you can paste to JIRA.
    Input : Synthesis/PT/VCLP/ANYtool log files
    Output : Txt file which contains  warning ID's and count.
END_MESSAGE
    printCust "$message";

}




###########################
# Concat input files & remove duplicate files
########################### 
sub concatAndUniq {
    print "Performing Concat and Uniq on input files...\n";
    my $outfile = shift;
    @catFile = `cat $outfile | sort -u `;
}
###########################
# Find Warnings and their ID's
###########################
my %warningHash; 
my @warningsWOID = ();
sub findWarnings {
    print "Finding Warnings..\n";
    foreach $line (@catFile) {
        #print $line; # prints concated file
        if ($line =~ m/^Warning/) {
            if ($line =~ /.*(\(.*\))/) {
                $warningNumber = $1;
                #print "warningNumber : $warningNumber\n";
                $warningHash{$1}{value} = "$warningHash{$1}{value}"+1;
                #print "warningHash{$1}{value} = $warningHash{$1}{value}\n";
                if ($warningHash{$1}{value} == 1) {
                    #print "Inside the assign\n";
                    chomp $line;
                    $warningHash{"$1"}->{Message} = $line;
                    #print "for ID $1 : $warningHash{$1}->{Message}\n";
                    #print Dumper \%warningHash;            
                }                  
            } else {                     
                #print $line;
                push (@warningsWOID, "$line");
                #printCust ("Warning Found by no Number");
            }

        }

    }

}
###########################
# Make JiRA TABLE
########################### 
sub createTable {
    open (OUT, ">", $JiraTable ) or die "Could not open $JiraTable$!\n";
    print OUT "|| Type || Num of Inst. || Status || Message || Waived/Fixed ||\n"; 
    foreach $key (keys %warningHash) { 
        print "key : $key, Count : $warningHash{$key}{value}, Message : $warningHash{$key}{Message},\n";
        print OUT "|$key|$warningHash{$key}{value}|(x)|$warningHash{$key}{Message}| |\n";
    }
    close OUT;
    printCust "Following are warnings without number an ID!";
    print "@warningsWOID\n";
    printCust "The Table has been created in $JiraTable!";
}



###########################
# Main CODE
########################### 

if ( @ARGV < 1) {
    scriptInfo();
    UsageScript();
    die;
}  

concatAndUniq(@ARGV);
findWarnings();
createTable();


