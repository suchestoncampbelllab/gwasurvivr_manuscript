#! /usr/bin/perl
use strict;
use warnings;

opendir OUT, "./";
my @outfiles = grep { $_ ne '.' && $_ ne '..' && $_ ne '.DS_Store' && $_ =~ /err$/} readdir(OUT);
close OUT;

open TIME, ">Times2.txt" or die$!;
print TIME "File\tUser_Time\tSNPs_Removed\tSNPs_Included\tTotal_Time\n";

foreach my $file (@outfiles) {
    	my $basename = $file;
    	$basename =~ s/.err//;
	
        open ERR, "$basename.err" or die$!;
        print TIME "$basename\t";
        
        while(<ERR>){
                chomp($_);
                if ($_ =~ /^User:/) {
                		chomp($_);
                		my @temp = split(":", $_);
                        print TIME "$temp[1]\t";
                }
                
                elsif ($_ =~ /SNPs were removed from/) {
                        my @temp = split(" ", $_);
                		print TIME "$temp[0]\t";
                }
                
                elsif ($_ =~ /SNPs were included in/) {
                		my @temp = split(" ", $_);
                		print TIME "$temp[2]\t";
                			
                }	
                	
                else {
                        next;
                }
        }
        
        close ERR;

        open OUTFILE, "$basename.out" or die$!;
       	
        while(<OUTFILE>) {
       		if ($_ =~ /^It took/) {
       				my @temp = split(" ", $_);
                    print TIME "$temp[2]\n";
                }
        
        	
        }	
        
        close OUTFILE;
        	
}

close TIME;
