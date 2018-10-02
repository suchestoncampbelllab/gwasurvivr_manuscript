#! /usr/bin/perl
use strict;
use warnings;

opendir OUT, "./";
my @outfiles = grep { $_ ne '.' && $_ ne '..' && $_ ne '.DS_Store' && $_ =~ /out$/ } readdir(OUT);
closedir OUT;

open TIME, ">gwassvTimes.txt" or die$!;
print TIME "File\tSeconds\n";

foreach my $file (@outfiles) {
    	my $basename = $file;
    	$basename =~ s/.out//;
	
        open OUT, "$file" or die$!;
        print TIME "$basename\t";
        
        while(<OUT>){
                chomp($_);
                if ($_ =~ /^It took/) {
                		chomp($_);
                		my @temp = split(" ", $_);
                        print TIME "$temp[2]\n";
                }	
                	
                else {
                        next;
                }
        }
        
        close OUT;

}

close TIME;