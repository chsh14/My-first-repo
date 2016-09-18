#!/usr/local/bin/perl5.12
use lib '/pri/chsh/5.18/5.18';
#use lib '/Users/chirayushah/Downloads/jira-client-automated-master/lib';
use JIRA::Client::Automated;
use Data::Dumper qw(Dumper);
use Getopt::Long qw(GetOptions);


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
print Dumper $issue;
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
           'id' => '11484'
        }
    ],
    'assignee' => {
        'name' => 'chsh'
    },
    'customfield_10332' => {     #Disipline
        'value' => 'Digital'
    }
});
print Dumper $issue;
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
        name => 'Major'
    },
    fixVersions => [
        {
        'name' => 'Quark Graviton Final',
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
        'value' => 'Quark Graviton'
        }
    ]
});
print Dumper $issue;

}


$url="http://projecttools.nordicsemi.no/jira";
$user="chsh";
$password="$ENV{'PASSWORD'}";
$jira = JIRA::Client::Automated->new($url, $user, $password);
$jira->trace(0);
my $arg_num = scalar @ARGV;  #getopt modifies the @ARGV array
#print Dumper $issues;
GetOptions( \%args,
        'Glu' => \$Glu,
        'ChipInt' => \$ChipInt,
        'GravF' => \$GravF
    ) or die "Usage: $0 --Glu or --ChipInt or --GravF\n";
#print "Arguments :" . $arg_num . "\n";
if ($arg_num == 1) {
    printCust "Pls Enter Summary [Required] :";
    print "Summary :";
    chomp ($summary=<>);
    printCust "Pls Enter Description [Optional] :";
    print "Description: ";
    $description=<STDIN>;
    chomp $description;
    if ($description eq '') {
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

