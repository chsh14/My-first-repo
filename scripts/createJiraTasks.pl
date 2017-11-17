#!/usr//bin/perl
use lib '/pri/chsh/5.18/5.18';
#use lib '/Users/chirayushah/Downloads/jira-client-automated-master/lib';
use JIRA::Client::Automated;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);
use Term::ANSIColor qw(:constants);


$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

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

sub createTaskGluonVFP1 {
 my $issue = $jira->create({
    # Jira issue 'fields' hash
    project     => {
        key => 'NRV',
        name => "Nano RV",
    },
    issuetype   => {
        name => "Task",      # "Bug", "Task", "Sub-task", etc.
    },
    summary     => $summary,
    description => $description,
    customfield_10531 => 'NRV-241', # Epic Link
    priority => {
        name => 'Major'
    },
    'components' =>  [
        {
            'name' => 'Gluon-V'
        },
    ],
    'assignee' => {
        'name' => 'chsh'
    }
});

showCreateTask($issue);


}
sub createTaskGluonFP1 {
    printCust "Creating task for GluonFP1..";

 my $issue = $jira->create({
    # Jira issue 'fields' hash
    project     => {
        key => 'IC',
        name => 'IC-Development',
    },
    issuetype   => {
        name => "Task",      # "Bug", "Task", "Sub-task", etc.
    },
    summary     => $summary,
    description => $description,
    customfield_10531 => 'IC-13484', # Epic Link
    priority => {
        name => 'Major'
    },
    fixVersions => [
        {
        'name' => 'Quark Gluon',
        'id' => '13727'
        }
    ],
    'components' =>  [
        {
            'name' => 'QUARK',
            'id' => '11411'
        },
        {
           'name' => 'Chip Integration',
           'id' => '11484'
        }
    ],
    'assignee' => {
        'name' => 'chsh'
    },
    'customfield_10332' => {     #Disipline
        'value' => 'Digital'
    },
    customfield_11035 => [
        {      #Product
        'value' => 'Quark Gluon'
        }
    ]
});

showCreateTask($issue);
}

sub createTaskCI {
  my $issue = $jira->create({
    # Jira issue 'fields' hash
    project     => {
        key => 'DESPROC',
        name => 'Design Chain processes',
    },
    issuetype   => {
        name => "Task",      # "Bug", "Task", "Sub-task", etc.
    },
    summary     => $summary,
    description => $description,
    customfield_10531 => $epic, #'IC-10915', # Epic Link (Improvements to CI Flow)
    priority => {
        name => 'Major'
    },
    'components' =>  [
        {
           'name' => 'Chip Integration',
        }
    ],
    'assignee' => {
        'name' => $ENV{'USER'},
    }
});
#print Dumper $issue;
showCreateTask($issue);
}

sub createTaskGraviton {
  my $issue = $jira->create({
    # Jira issue 'fields' hash
    project     => {
        key => 'IC',
        name => 'IC-Development',
    },
    issuetype   => {
        name => "Task",      # "Bug", "Task", "Sub-task", etc.
    },
    summary     => $summary,
    description => $description,
    customfield_10531 => 'IC-5835', # Epic Link Graviton IC-Implementation
    priority => {
        name => 'Critical'
    },
    fixVersions => [
        {
        'name' => 'Quark Graviton Final'
        }
    ],
    'components' =>  [
        {
            'name' => 'QUARK',
            'id' => '11411'
        },
        {
           'name' => 'Chip Integration',
           'id' => '11484'
        }
    ],
    'assignee' => {
        'name' => 'chsh'
    },
    'customfield_10332' => {     #Disipline
        'value' => 'Digital'
    },
    customfield_11035 => [
        {      #Product
        'value' => 'Quark Graviton'
        }
    ]
});
#print Dumper $issue;
showCreateTask($issue);
}

sub createTaskYodaMPW3 {
  my $issue = $jira->create({
    # Jira issue 'fields' hash
    project     => {
        key => 'YODA',
        name => 'Yoda',
    },
    issuetype   => {
        name => "Task",      # "Bug", "Task", "Sub-task", etc.
    },
    summary     => $summary,
    description => $description,
    customfield_10531 => 'YODA-1437', # Epic Link Graviton IC-Implementation
    priority => {
        name => 'Critical'
    },
    fixVersions => [
        {
            'name' => 'Yoda GS Proto3'
        },
        {
            'name' => $RTL_LAY
        }
    ],
    'components' =>  [
        {
           'name' => 'Chip Integration'
        }
    ],
    'assignee' => {
        'name' => 'chsh'
    },
    'customfield_10332' => {     #Disipline
        'value' => 'Digital'
    },
    'labels' => [
           'TeamAtomIC'
    ],
    customfield_11035 => [
        {      #Product
        'value' => 'Yoda FP1'
        }
    ]
});
#print Dumper $issue;
showCreateTask($issue);

}


sub showCreateTask {
    my %hash = %{$_[0]}; #passing hashref
    $self = $hash{'self'};
    $key  = $hash{'key'};
    @splitArr = split /\/rest\//, $self;
    #print "@splitArr\n";
    if (scalar @splitArr != 2) { print Dumper $_[0]; die " ERROR : Jira rest API output format has changed..";}
    printCust "There you go $ENV{'USER'}!";
    print GREEN, "$splitArr[0]/browse/$key\n", RESET;
}


$url="https://projecttools.nordicsemi.no/jira";
$user="chsh";
$password="$ENV{'PASSWORD'}";
$jira = JIRA::Client::Automated->new($url, $user, $password);
# Want to debug ? set the trace to 1
$jira->trace(0);
my $arg_num = scalar @ARGV;  #getopt modifies the @ARGV array
#print Dumper $issues;
GetOptions( \%args,
        'Glu' => \$Glu,
        'ChipInt' => \$ChipInt,
        'GravF' => \$GravF,
        'GluV' => \$GluV,
        'YodaMPW3' => \$YodaMPW3
    ) or die "Usage: $0 --Glu or --ChipInt or --GravF\n";
#print "Arguments :" . $arg_num . "\n";
if ($arg_num == 1) {
    printCust "Pls Enter Summary [Required] :";
    print "Summary :";
    chomp ($summary=<>);
    if ($YodaMPW3) {
        $elaborateWarnings = "DoD:
  1) Fix the above warning
  2) Check the jenkins logs and confirm its fixed
  3) Close the task or reassign to the next responsible";
        $RTL_LAY="RTL2";
        $description = $elaborateWarnings;
    } else {
    printCust "Pls Enter Description [Optional] [type END to exit]:";
    print "Description: ";
    while (<STDIN>) {
        last if /^END$/;
        $description .= $_;
    }
    chomp $description;
    }
    if ($description eq "") {
        #print "Description Empty";
        $description = "Pls Enter the description";
    }
    #print "$summary,$description\n";
    if ($Glu) {
    #Call the gluon
        createTaskGluonFP1
    } elsif ($ChipInt) {
        printCust "EPIC link other than [Default : IC-10915] [y/n] ?";
        print "Answer :";
        chomp ($answer=<STDIN>);
        if ($answer eq "y" ) {
            print "Epic ID :";
            chomp ($epic=<STDIN>);
        } else {
            $epic = 'IC-10915'
        }
        #Call Chip Int ;
        createTaskCI
    } elsif ($GravF) {
        # Call GravitonFinal;
        createTaskGraviton
    } elsif ($GluV) {
        createTaskGluonVFP1
    } elsif ($YodaMPW3) {
       createTaskYodaMPW3
    } else {
        printCust "Better Luck next time $USER..!";
    }
} else {
    die "Need atleast one argument $!";
}

=cut
@fieldsToReturn = qw(resolution status project );
$fields=\@fieldsToReturn;
$jql='assignee=chsh';
$issues = $jira->search_issues($jql,1,100);



#my $issue = $jira->get_issue('DESPROC');
#createTaskGluonFP1
#$key=101407;

