#!/usr/local/bin/perl 
#use warnings;
use lib '/Users/chirayushah/Documents/git_directory/scripts';
use WaivedWarnings;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);
my $JiraTable = "JiraTableToPaste.txt"; 
my $packagePath = "/Users/chirayushah/Documents/git_directory/scripts/WaivedWarnings.pm";
###########################
# Custom Print Function
###########################  
sub printCust {
    if (exists $_[1]) {
        print "-----------------\n";
        print "$_[0], $_[1]\n";
        print "------------------\n";
    } else {
        print "-----------------\n";
        print "$_[0]\n";
        print "------------------\n";
    }
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
    Output : Txt file which contains  warning ID's and count ($JiraTable).
END_MESSAGE
    printCust "$message";

}




###########################
# Concat input files & remove duplicate files
########################### 
my @catFile;
sub concatAndUniq {
    print "Performing Concat and Uniq on input files...\n";
    my $outfile = shift;
    @catFile = `cat $outfile | sort -u`;
}
###########################
# Find Warnings and their ID's
###########################
my %warningHash; 
my @warningsWOID = ();
my @waivedWarningsArray;
my @notWaivedWarnings; 
sub findWarnings {
    print "Finding Warnings..\n";
    foreach $line (@catFile) {
        #print $line; # prints concated file
        if ($line =~ m/^Warning/) {
            if ($line =~ /.*\((.*)\)/) {
                $warningNumber = $1;
                #print "warningNumber : $warningNumber\n";
                $warningHash{$1}{value} = "$warningHash{$1}{value}"+1;
                #print "warningHash{$1}{value} = $warningHash{$1}{value}\n";
                if ($warningHash{$1}{value} == 1) {
                    $returnCheck = checkWaived ($warningNumber,\@waivedSynID); 
                    if ($returnCheck != 1) {
                        $returnCheck = checkWaived ($line,\@waivedbyMessage);
                    }
                    #print "Inside the assign\n";
                    chomp $line;
                    $warningHash{"$1"}->{Message} = $line;
                    #print "for ID $1 : $warningHash{$1}->{Message}\n";
                    #print Dumper \%warningHash;            
                    if ($returnCheck != 1) {
                        printCust "NOT WAIVED BEFORE!";
                        #printCust "ID : $warningID Not Waived before..";
                        push (@notWaivedWarnings,$warningNumber);
                    } else {
                        push (@waivedWarningsArray,$warningNumber);
                    }
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
    printCust "Following are warnings without an ID!";
    print "@warningsWOID\n";
    printCust "The Table has been created in $JiraTable!";
}

###########################
# Check for Waived warnings ID's.
########################### 

sub checkWaived {
    # Two arguments  1) Scalar , 2) Array. 
    my $foundWaived = 0; 
    $warning = $_[0];
    @waived = @{$_[1]};
    printCust "Checking if \"$warning\" is waived of not..";
    if (scalar(@waived) == 0) { 
        printCust "Array @waived contains (@waived) elements.. exiting" ; 
        return $foundWaived;
    } else {
        foreach $waived_elem (@waived) {
            chomp($warning);
            #printCust "Comparing \"$warning\" & \"$waived_elem\"";
            if ($warning eq $waived_elem) {
                printCust "Found Waived warning..";           
                $foundWaived = 1;
                return $foundWaived; 
            }
        }
    }
    return $foundWaived;
    
}


###########################
# Check for Waived warnings Messages's.
###########################  
sub checkWaivedMessage {
    my $foundWaived = 0


}

###########################
# Display Waived and Not waived Warnings
########################### 

sub displayResults {
    print "@_\n";
}


###########################
# Find Not waived warnings from the file.
########################### 

sub findNotWaivedIDs {
    open (PACKAGE,">>",$packagePath) or die "Cannot open $packagePath for append $!\n";
    foreach my $notWaived (@_) {
        print "Searching for $notWaived ....\n";
        my $cnt = 0;
        foreach my $lines (@catFile) {
            #print "$lines\n";
            if ($lines =~ m/$notWaived/) {
                $cnt++;
                printCust "What about : $lines ?";
                print "Waive[Y]/NoWaive[N]:";
                chomp ($waiveIt=<STDIN>);
                if ($waiveIt =~ /^[Yy]/) {
                    print PACKAGE "push (\@waivedbyMessage,\"$lines\")\;\n";
                    print "WAIVED!\n";
                } else {
                    print "hmm..A Real one huh..\n";
                    print "You can alternatively add the ID to \@waivedSynID in $packagePath\n";
                }
                if ($warningHash{$key}{value} == $cnt) {
                    print "There are only $warningHash{$key}{value} warning(s) in the file\n";
                    break
                }
            }
        }
        if ($cnt == 0) {
            die "Warning Not found.. Thats Impossible!\n";
        }
    }
    close PACKAGE;


}

###########################
# Main CODE
########################### 

if ( @ARGV < 1) {
    scriptInfo();
    UsageScript();
    die;
}  

my $waive;
GetOptions('waive' => \$waive) or die "Usage: $0 --waive\n";
concatAndUniq(@ARGV);
findWarnings();
open (TMP,">","tmp") or die;
print TMP "@catFile\n";
close TMP;
createTable();
if ($waive) {
    print "Waived Warnings In FP1 :";
    displayResults(@waivedWarningsArray);
    print "-----------------------------\n";
    print "Not Waived Warnings :";
    displayResults(@notWaivedWarnings);
    print "-----------------------------\n";
    if (scalar(@notWaivedWarnings) != 0) {  
        print "hi there $ENV{'USER'}!\n";
        printCust "Do you want to go thr the warnings containing this ID's [yes/no]?";
        print "Answer : ";
        chomp ($answer=<STDIN>);
        if ( $answer =~ /^[yY]/ ) {
            printCust "Thats what I expected.";
            findNotWaivedIDs(@notWaivedWarnings); 
        } else {
            printCust "Very Well then";
        }
    } else {
        printCust "All the warnings are already Waived!"
    }
}  
print "Have a nice day!\n";





