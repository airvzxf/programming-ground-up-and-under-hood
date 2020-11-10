#!/usr/bin/perl -w

# encoding -> character definition files
%prefer=qw(
gb		gbchar.txt
);

$enc = ($ARGV[0]||"");
$prefer = "gbchar.txt";
foreach $key (keys %prefer) { 
    $prefer=$prefer{$key} if $enc=~/$key/i;
    @charfile = (@charfile,$prefer{$key});
}

# get the script's path to load character definition files
$_ = ($0 || "");
m@((.*/)*)([^/]*)@;
$p=("$1" || ""); # script's path

# read different character definition files
$CJKchar[65536]="";
foreach my $t (@charfile) {
    ($t ne $prefer) && read_char_file("$p$t");
}
read_char_file("$p$prefer");

#
# output
#

print '\def\CJKpreproc{}';
print '\def\CJK@standardBinding{}%',"\n";
print '\usepackage{CJK}%'."\n";
print '\begin{CJK}{GBK}{}%'."\n";
print '%
\def\JDchar#1[#2]#3#4{\CJKchar[#2]{#3}{#4}}%
\pdfstringdefDisableCommands{%
  \def\JDchar#1[#2]#3#4{<#1-CJK[#2]<#3><#4>>}%
}%
';
while (<STDIN>) {
    s/\\p@/pt/g;
    while (/\\Character\{([0-9]+)\}/) {
	    print "$`".($CJKchar[$1]||"$&");
	$_ = "$'";
    }
    print;
}

sub read_char_file {
    my($f) = @_;
    print STDERR "$f--\n";
    open FH, $f or return;
    while ($_ = <FH>) {
        chomp; s/\r//g;
        ($code,$CJKchar)=split(/ /,$_,2);
	if (substr($CJKchar,0,9) eq '\CJKchar[') {
		$CJKchar = "\\JDchar{$code}".substr($CJKchar,8);
	}
        $CJKchar[$code] = $CJKchar;
    }
    close FH;
    print STDERR "$f loaded\n";
}
