#!/usr/bin/perl

##############################################################################
# Mina Jafari, 29 May 2015                                                   #
# Purpose: This script checks the walltime and elapsed time for the running  #
# jobs, if the time difference is less than or equal to 20 hours, it adds 24 #
# hours to the walltime of the job.                                          #
##############################################################################


use strict;
use warnings;
use Scalar::Util qw(looks_like_number);

my $timeDifference = 20;
my $extraTime = 48;
my $userID = `whoami`;
my $screenOut = `qstat -tau $userID`;
my @listOfJobs = split /\n/, $screenOut;
my @check;

shift @listOfJobs;
shift @listOfJobs;
shift @listOfJobs;
shift @listOfJobs;
shift @listOfJobs;

for (@listOfJobs)
{
    push @check, $_;
    @check = split / +/, $_;

    push my @jobID, $check[0];
    @jobID = split /\./, $check[0];

    if (index($jobID[0], "[") != -1)
    {
        $jobID[0] =~ s/(\[\d\])/\[\]/g;
    }
    my @elapsedTime = split /:/, $check[10];
    my @wallTime = split /:/, $check[8];

    if (looks_like_number($elapsedTime[0]) && 
        $wallTime[0] - $elapsedTime[0] <= $timeDifference)
    {
        my $hour = $wallTime[0]+$extraTime;
        my $newTime = "$hour:00:00";
        print "job ID: ", $jobID[0], ", ", "previous walltime= ", $wallTime[0], ", ", "new walltime= ", $newTime, "\n";
        system "qalter $jobID[0] -l walltime=$newTime";
    }
}
