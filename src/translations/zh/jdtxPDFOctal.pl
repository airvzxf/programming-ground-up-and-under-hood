#!/usr/bin/perl -pi
#

if (m/^(\\BOOKMARK \[.*\]\[.*\]\{.*\}\{)(.*)(\}\{.*})(\s*)$/) {
	my ($a,$b,$c,$d) = ($1,$2,$3,$4);
	if ($b =~ m/<\d+-CJK\[[^\[]*\]<.*><.*>>/) {
		$_ = join('',$a,&transferCJK($b),$c,$d);
	}
}

sub transferCJK {
    my @result;
    my $CJKstr = shift;
    push @result, "\\376\\377";
    while ($CJKstr) {
	if ($CJKstr =~ m/^<(\d+)-CJK\[\w*\]<\"?\w+><\"?\w+>>/) {
	    push @result, sprintf("\\%03o\\%03o", int($1/256), $1%256);
	    $CJKstr = $';
	}
	else {
	    push @result, sprintf("\\000\\%03o", ord(substr($CJKstr,0,1)));
	    $CJKstr = substr($CJKstr,1);
	}
    }
    return @result;
}

