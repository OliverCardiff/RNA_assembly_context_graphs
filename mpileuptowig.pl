use strict;
use warnings;

my $lastC = "";

while(<>)
{
	chomp;
	
	(my $c, my $start, undef, my $depth) = split; 
	if ($c ne $lastC) 
	{ 
		print "$c\n"; 
	}
	$lastC=$c;
	next unless $. % 10 ==0;
	print "$start\t$depth\n";
}
