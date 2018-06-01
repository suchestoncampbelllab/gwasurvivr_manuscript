#!/usr/bin/perl
use strict;
use warnings;

opendir OUT, "./";
my @outfiles = grep { $_ ne '.' && $_ ne '..' && $_ ne '.DS_Store' && $_ =~ /out$/} readdir(OUT);
close OUT;

open TIME, ">Times.txt" or die$!;

foreach my $file (@outfiles) {
    
    open IN, "$file" or die$!;
    
    while(<IN>){
        chomp($_);
        if ($_ =~ /NODELIST/) {
            print TIME "$file\t$_\t";
        }
        elsif ($_ =~ /^It took/) {
            print TIME "$_\n";
        }
        else {
            next;
        }
    }
    close IN;
}
close TIME;