#!/usr/bin/perl
undef $/; 
open(INDEX, "index.xml"); 
$tmp = <INDEX>; 
close(INDEX); 
$tmp =~ s!-->.*?</indexentry>!-->!s; 
open(INDEX, ">index.xml"); 
print INDEX $tmp; 
close(INDEX);
