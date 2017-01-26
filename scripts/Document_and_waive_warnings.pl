#!/usr/local/bin/perl
use File::Basename;
use Cwd;
#use warnings;
#use diagnostics;
#use List::MoreUtils 'true';
use Text::Wrap;
$Text::Wrap::columns = 70;
$packagePath = "$ENV{'VC_WORKSPACE'}/methodology/DesignKit/scripts/synopsys/dc/scripts/waive_scripts/WaivedWarnings.pm";

use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);
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
Script takes multiple files and show waived/notwaived warnings and a chance to waive them.
    Usage :
          Example 1 : $0 <log1> [log2] --syn ; Read WaivedWarnings.pm from syn/rm_dc_* directory
          Example 2 : $0 *.log; --lec ; Read WaivedWarnings.pm from ver_syn/lec*/rm_dc*/ directory
          Example 3 : $0 *.log; --sta ; Read WaivedWarnings.pm from tim/rm_pt*/ directory
          Example 4 : $0 *.log  ; This will give error.
END_MESSAGE

    printCust "$message";
}



sub scriptInfo {
    my $message = <<"END_MESSAGE";
Hi There $ENV{'USER'}!
    This script creates JIRA Table in $JiraTable, which you can paste to JIRA.

    Input : SYN/PT/FM/ANYtool log/reports files
    Output : Txt file which contains  warning ID's and count ($JiraTable).

    It can also waive warnings for you. By default, it uses \"$packagePath\" to locate the previous warnings.
    Depending on the switch it use different to look for already waived warnings.

    Input : Log files
    Output : Waived warnings in $packagePath
END_MESSAGE
    printCust "$message";

}

$SIG{'INT'} = sub {
    printCust "Ctrl-C found..!";
    print "Gracefully exiting the code...\n";
    die;
};


###########################
# Concat input files & remove duplicate files
###########################
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
# Find Warnings and their ID's
###########################
my %warningHash;
my @warningsWOID = ();
my @waivedWarningsArray; # Contains ID's of waived warnings
my @notWaivedWarnings; # Contains ID's of Not waived warnings
my @waivedWarningbyMsg; # contains lines which are waived by message
my %warningMsgHash;
sub findWarnings {
    # Two arguments  1) Array , 2) Array.
    my @waivedbyID = @{$_[0]};
    my @waivedbyMess = @{$_[1]};
    print "Finding Warnings..\n";
    foreach $line (@catFile) {
        #print "$line\n"; # prints concated file
        if ($line =~ m/Warning:/) {
            #print "$line\n";
            if ($line =~ /.*\((.*-\d+)\)/) {
                $warningNumber = $1;
                $warningMsg = $line;
                #chomp $line;
                #print "warningNumber : $warningNumber\n";
                #printCust "$line";
                $warningHash{$warningNumber}{value} = "$warningHash{$warningNumber}{value}" + 1;
                #print "warningHash{$1}{value} = $warningHash{$1}{value}\n";
                if ($warningHash{$warningNumber}{value} == 1) {
                    $warningHash{$warningNumber}->{Message} = $line;# Save the message of first warning for table
                }
                $returnCheckID = checkWaived ($warningNumber,\@waivedbyID);
                if ($returnCheckID == 1) {
                    #printCust " ReturnCheckID : $line";
                    push (@waivedWarningsArray,$warningNumber);
                    $warningHash{$warningNumber}{waived} = 1;
                }
                if ($returnCheckID != 1) {

                    #printCust "$returnCheckID: $line";
                    my $newLine = `echo "$line" | sed "s/'//g"`;
                    #print "$newLine\n";
                    $returnCheckMsg = checkWaived ($newLine,\@waivedbyMess);
                    #printCust "$returnCheckMsg";
                }    #
                    #print "for ID $1 : $warningHash{$1}->{Message}\n";
                    #print Dumper \%warningHash;
                if ($returnCheckMsg != 1 && $returnCheckID != 1) {
                    #printCust "$line : NOT WAIVED BEFORE!";
                    #printCust "ID : $warningID Not Waived before..";
                    push (@notWaivedWarnings,$warningNumber);
                    $warningHash{$warningNumber}{waived} = 0;
                    $warningMsgHash{$warningMsg}{waived} = 0;
                } elsif ($returnCheckMsg == 1) {
                    $returnCheckMsg = 0;
                    push (@waivedWarningbyMsg,$line);
                    $warningMsgHash{$warningMsg}{waived} = 1;
                }
            } else {
                #print $line;
                push (@warningsWOID, "$line\n");
                #printCust ("Warning Found by no Number");
            }
        }
    }
    #print "@waivedWarningbyMsg\n";
}
###########################
# Make JiRA TABLE
###########################
sub createTable {
    open (OUT, ">", $JiraTable ) or die "Could not open $JiraTable$!\n";
    open (WOID, ">", $warningsWO_ID ) or die "Could not open $warningsWO_ID$!\n";
    print OUT "|| Type || Num of Inst. || Status || Message || Waived/Fixed ||\n";
    foreach $key (keys %warningHash) {
        #print "key : $key, Count : $warningHash{$key}{value}, Message : $warningHash{$key}{Message},\n";
        if ($warningHash{$key}{waived} == 1) {
            print OUT "|$key|$warningHash{$key}{value}|(/)| $warningHash{$key}{Message} | Waived |\n";
        } else {
            print OUT "|$key|$warningHash{$key}{value}|(x)| $warningHash{$key}{Message} | |\n";
        }
    }
    close OUT;
    #printCust "Following are warnings without an ID!";
    print WOID "@warningsWOID";
    printCust "The Table for waived/not IDs has been created in $JiraTable!";
    printCust "Warnings without an ID! : $warningsWO_ID";
}

sub createMsgTable {
    open (OUT1, ">", $JiraMsgTable ) or die "Could not open $JiraMsgTable$!\n";
    print OUT1 "|| Message || status || Waived/Fixed  || Comments ||\n";
    foreach $key (keys %warningMsgHash) {
       if ($warningMsgHash{$key}{waived} == 1) {
           print OUT1 "| $key | (/) | Waived | |\n";
       } else {
           print OUT1 "| $key | (x) | | |\n";
       }
    }
    close OUT1;
    printCust "The Table for waived/not  Messages has been created in $JiraMsgTable!";
    print "\n";
}

###########################
# Check for Waived warnings ID's.
###########################

sub checkWaived {
    # Two arguments  1) Scalar , 2) Array.
    my $foundWaived = 0;
    $warning = $_[0];
    @waived = @{$_[1]};
    #printCust "Checking if \"$warning\" is waived of not..";
    if (scalar(@waived) == 0) {
        #print @waived;
        #printCust "Array @waived contains (@waived) elements.. exiting" ;
        return $foundWaived;
    } else {
        foreach $waived_elem (@waived) {
            chomp($warning);
            #printCust "Comparing \"$warning\" & \"$waived_elem\"";
            if ($warning eq $waived_elem) {
                #printCust "Found Waived warning..";
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
    #open (PACKAGE,">>",$packagePath) or die "Cannot open $packagePath for append $!\n";
    my @notWaivedWarn = @{$_[0]};
    #print "@notWaivedWarn";
    my @waivedbyID = @{$_[1]};
    my @waivedbyMess = @{$_[2]};
    my $waivedVarName = $_[3];
    $breakTheLoop=0;
    foreach my $notWaived (@notWaivedWarn) {
        print "Searching for $notWaived ....\n";
        my $cnt = 0;
        foreach my $lines (@catFile) {
            chomp($lines);
            #print "$lines\n";
            if ($lines =~ /\b$notWaived\b/) {
                my $newLine = `echo "$lines" | sed "s/'//g"`;
                #print "$newLine\n";
                my $returnCheckMsg = checkWaived ($newLine,\@waivedbyMess);
                #print "Waived/No Waived = $returnCheckMsg\n";
                #my @count = grep {/$line/} @waivedbyMess;
                if ($returnCheckMsg != 1) {
                    #$#count = -1;
                    #print "$lines matched skipping the line\n";
                    # } else {
                    $cnt++;
                    print "--------------------------------------------------\n";
                    print "What about : $lines ? \n";
                    print "--------------------------------------------------\n";
                    print "WaiveID[y]/WaiveByMessage[m]/NoWaive[n]/NextID[id]/Exit[e]:";
                    chomp ($waiveIt=<STDIN>);
                    if ($waiveIt =~ /^[Yy]/) {
                        #sed -i doesnt work somehow.. :(
                        `sed -e "/^\@$waivedVarName/a push(\@$waivedVarName,\'$notWaived\');" $packagePath > temp && mv temp $packagePath `;
                        print "Waived in $packagePath !\n";
                        last;
                    }
                    elsif ($waiveIt=~ /^id/) {
                        last;
                    }
                    elsif ($waiveIt=~ /^[Mm]/ ) {
                        `sed -e '/^\@waivedbyMessage/a push(\@waivedbyMessage,"${lines}");' $packagePath > temp && mv temp $packagePath `;
                        print "WAIVED in $packagePath !\n";
                    } elsif ($waiveIt =~ /^[Ee]/) {
                        $breakTheLoop=1;
                    } else {
                        print "hmm..A Real one huh..\n";
                        print "You can alternatively add the ID to \@waivedbyID in $packagePath\n";
                    }
                    if ($warningHash{$key}{value} == $cnt) {
                        print "There are only $warningHash{$key}{value} warning(s) in the file\n";
                        last;
                    }
                }
                if ($breakTheLoop) {last;}
            }
        }
        if ($cnt == 0 && !$breakTheLoop) {
            die "Warning Not found.. Thats Impossible!\n";
        } elsif ($breakTheLoop) {
            last;
        }
    }




    #close PACKAGE;


}


sub uniq {
    #print "@_\n";
    my %seen;
    grep !$seen{$_}++, @_;
}

sub array_check {
    my @arrayCheck = @{$_[0]};
    if (scalar(@_) == 0) {
        printCust "Warning: Array \@waivedbyID is empty... continuing.. (CHSH-1)";
        #die "$!";
    }
}

sub lines_to_add {
  my $message = <<"END_MESSAGE";
    \$packagePath =  "$_[0]/WaivedWarnings.pm";
    require "\$packagePath";
    WaivedWarnings->import();
END_MESSAGE
  printCust "$message";
}
###########################
# Main CODE
###########################

if ( @ARGV < 1) {
    scriptInfo();
    UsageScript();
    die;
}

my $debugCat=0;
my $waivedVarName="waivedbyID";
# Add your switch below
GetOptions( 'syn' => \$syn,
            'check_design' => \$check_design,
            'pt' => \$pt,
            'lec' => \$lec,
            'jenkins' => \$jenkins) or die "Usage: $0 --lec --syn\n";

# Add elsif clause to look for WaivedWarnings in particular directory
if ($syn) {
    $packagePath = "$ENV{'N_DESIGN_DIR'}/syn/rm_dc_scripts/WaivedWarnings.pm";
    require "$packagePath";
    WaivedWarnings->import();
} elsif ($lec) {
    $packagePath =  "$ENV{'N_DESIGN_DIR'}/ver_lay/lec_fmlty/rm_dc_scripts/WaivedWarnings.pm";
    require "$packagePath";
    WaivedWarnings->import();
} elsif ($check_design) {
    $packagePath =  "$ENV{'N_DESIGN_DIR'}/syn/rm_dc_scripts/WaivedWarnings.pm";
    require "$packagePath";
    WaivedWarnings->import();
    @waivedbyID = @waived_list;
    $waivedVarName = "waived_list";
} elsif ($pt) {
    $packagePath =  "$ENV{'N_DESIGN_DIR'}/tim/rm_pt_scripts/WaivedWarnings.pm";
    require "$packagePath";
    WaivedWarnings->import();
} else {
    printCust "Warning : No known switch specified.. ";
    my $dir = getcwd;
    #`rsync -avz $packagePath $dir`;
    #printCust "Copied template from $packagePath to $dir";
    my $message = <<"END_MESSAGE";
    Next Steps  : Copy the template from $packagePath to  $dir
                : Add following lines in $0
                : Look for examples in script 
END_MESSAGE
    printCust $message;
    lines_to_add($dir);
    printCust "Also add your switch for your tool";
    die "Usage: $0 --lec or --syn or --check_design -or --pt\n";
}
concatAndUniq(@ARGV);
array_check(@waivedbyID);
findWarnings(\@waivedbyID,\@waivedbyMessage);
if ($debugCat) {
    open (TMP,">","tmp") or die;
    print TMP "@catFile\n";
    close TMP;
}
createTable();
createMsgTable();
my $packageBase = basename($packagePath);
print "Waived Warnings by ID from \"$packageBase\":";
@waivedWarningsArray = uniq(@waivedWarningsArray);
displayResults(@waivedWarningsArray);
print "-----------------------------\n";
print "Num of warnings waived by messages from \"$packageBase\":";
print scalar (@waivedWarningbyMsg),"\n";
print "-----------------------------\n";
print "Not Waived by Warnings ID's :";
@notWaivedWarnings = uniq(@notWaivedWarnings);
displayResults(@notWaivedWarnings);
print "-----------------------------\n";
if (scalar(@notWaivedWarnings) != 0 && ($jenkins == 0)) {
    print "hi there $ENV{'USER'}!\n";
    printCust "Do you want to go thr not waived warnings ID's [yes/no]?";
    print "Answer : ";
    chomp ($answer=<STDIN>);
    if ( $answer =~ /^[yY]/ ) {
        printCust "Thats what I expected.";
        findNotWaivedIDs(\@notWaivedWarnings,\@waivedbyID,\@waivedbyMessage,$waivedVarName);
    } else {
        printCust "Not interested.. Very Well then";
    }
} elsif (scalar(@notWaivedWarnings) != 0 && ($jenkins == 1)) {
    printCust "Error : There are unwaived warnings IDs in current run. [CHSH-1]"; 
} else {
    printCust "All the warnings are already Waived!"
}
print "Have a nice day!\n";





