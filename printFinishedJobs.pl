#!/usr/bin/perl

##############################################################################
# Mina Jafari, 29 May 2015                                                   #
# Purpose: This script checks the walltime and elapsed time for the running  #
# jobs, if the time difference is less than or equal to 20 hours, it adds 24 #
# hours to the walltime of the job.                                          #
##############################################################################


use strict;
use warnings;
#use Scalar::Util qw(looks_like_number);

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
        $jobID[0] =~ s/(\[1\])/\[\]/g;
    }

}
