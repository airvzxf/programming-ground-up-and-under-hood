#!/usr/bin/perl

open CP936, "CP936.TXT" or die "Cannot open file! $!";

while (<CP936>) {
    chomp;
    
    ($gbk, $unicode) = split /\s+/, $_;
    
    $gbk_left = hex($gbk) >> 8;
    $gbk_right = hex($gbk) & 0x00FF;

    $gbk_str = sprintf("\177%c\177%d\177", $gbk_left, $gbk_right);
    
    $unicode_dec = hex($unicode);
    $unicode_hex = sprintf("%X",$unicode_dec);

    print "$unicode_dec \\CJKchar[GBK]{$gbk_left}{$gbk_right}\n";
}

close CP936;
