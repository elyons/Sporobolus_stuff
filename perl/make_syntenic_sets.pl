#!/usr/bin/perl
use strict;
use Data::Dumper;

my $pyram_file = shift;
my $stapf_file = shift;

unless (-r $pyram_file && -r $stapf_file) {die "Usage: $0 <pyramidalis_file> <stapfianus_file>\nNote:  query organism is how files are named.";}

my $data1 = process_file($pyram_file, 2);
my $data2 = process_file($stapf_file, 3);


my %seen;
foreach my $item1 (keys %$data1) {
  next if $seen{$item1};
  $seen{$item1} =1;
  my %data;
  $data{$item1}=1;
  foreach my $item2 (keys %{$data1->{$item1}}) {
    $data{$item2} =1;
    foreach my $item3 (keys %{$data2->{$item2}}) {
      $data{$item3}=1;
      $seen{$item3}=1;
    }
  }
  print join ("\t", scalar keys %data, sort keys %data),"\n";
}


sub process_file {
  my $file = shift;
  my $matches = shift; #number of syntenic genes to use.
  my %data;
  open (IN, $file);
  while (<IN>) {
   chomp;
   next if /^#/;
   next unless $_;
   my @line = split/\t/;
   my $count = 0;
   foreach my $item (split /,/, $line[2])
    {
     next if $count == $matches;
     $count++;
     next if $item eq "proxy";
     $item =~ s/-\d+$/-1/; 
     $line[1] =~ s/-\d+$/-1/;
     $data{$line[1]}{$item}=1;
    }
  }
  close IN;
 return \%data;

}
