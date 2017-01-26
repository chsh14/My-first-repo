#!/usr/local/bin/perl
my $JiraTable = "JiraTableIDToPaste.txt";
my $JiraMsgTable = "JiraTableMsgToPaste.txt";
my $warningsWO_ID = "WarningsWithoutID.txt"; 

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
Script takes multiple VCLP log files and show waived/notwaived warnings and gives a chance to waive them.
    Usage :
          Example 1 : $0 <log1> [log2]  ; Read WaivedWarnings.pm from vclp dir
END_MESSAGE

    printCust "$message";
}

$SIG{'INT'} = sub {
    printCust "Ctrl-C found..!";
    print "Gracefully exiting the code...\n";
    die;
}; 

my @catFile;
sub concatAndUniq {
    my @fh;
    #print "Performing Concat and Uniq on input files \"@ARGV\"\n";
    foreach $a (@ARGV) {
        if ( -e $a && !($a =~ /temp.log/)) {
            print "Opening $a ...\n";
            open my $fh, '<', $a or die "Unable to open '$a' for reading: $!";
            push @fh, $fh;
        } else {
            print "$a is not a file or file is set to be ignored\n";
        }
    }
    #print "@fh\n";
    while (grep defined, my @lines = map scalar <$_>, @fh) {
        for my $fh1 (@lines) {
            chomp $fh1;
            #print "$fh1\n";
            push @catFile,$fh1;
        }
    }
} 

###########################
# Find VCLP Warnings and their ID's
###########################  
#
my %warningHash;
my @warningsWOID = (); 
sub findWarnings {
    print "Finding Warnings..\n"; 
    foreach $line (@catFile) { 
        if ($line =~ m/Warning\]/) {
            if ($line =~ /.*\]\s*(.*):/) {
                $warningNumber = $1;
                $warningMsg = $line;
                $captureNext=1;
                #print "warningNumber : $warningNumber\n";
                $warningHash{$warningNumber}{value} = "$warningHash{$warningNumber}{value}" + 1; 
                if ($warningHash{$warningNumber}{value} == 1) {
                    $warningHash{$warningNumber}{line} = $line;# Save the message of first warning for table
                } 
                #printCust "$line";
            } else {
                push (@warningsWOID, "$line\n"); 
            }
        } elsif ($captureNext==1) {
            $captureNext=0;
            if ($warningHash{$warningNumber}{value} == 1) { 
                $warningHash{$warningNumber}{Nextline} = $line;
            }
            #printCust "$line";
        }
    }

}
###########################
# Make JiRA TABLE
########################### 
#
sub createTable { 
    open (OUT, ">", $JiraTable ) or die "Could not open $JiraTable$!\n"; 
    open (WOID, ">", $warningsWO_ID ) or die "Could not open $warningsWO_ID$!\n"; 
    print OUT "|| Type || Num of Inst. || Status || Message || Waived/Fixed ||\n"; 
    foreach $key (keys %warningHash) { 
        print "key : $key, Count : $warningHash{$key}{value}, Message : $warningHash{$key}{line}, NextLine : $warningHash{$key}{Nextline} \n";
        if ($warningHash{$key}{Nextline} eq "") {
            print "NextLine is empty\n";
            print OUT "|$key|$warningHash{$key}{value}|(x)| $warningHash{$key}{line} | |\n"; 
        } else {
            print OUT "|$key|$warningHash{$key}{value}|(x)| $warningHash{$key}{Nextline} | |\n"; 
        }
        if ($warningHash{$key}{waived} == 1) {
            print OUT "|$key|$warningHash{$key}{value}|(/)| $warningHash{$key}{line} | Waived |\n";
        } 

    }
    close OUT; 
    print WOID "@warningsWOID"; 
    close WOID;
    printCust "The Table for waived/not IDs has been created in $JiraTable!";
    printCust "Warnings without an ID! : $warningsWO_ID"; 
}


concatAndUniq(@ARGV); 
findWarnings;
createTable;
