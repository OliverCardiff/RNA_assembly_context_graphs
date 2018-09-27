use strict;
use warnings;

my %bl_own_st;
my %bl_sc_st;
my %bl_sc_ed;

my %hit_reverse;
my %hit_perc;

my %hit_id;

my $old_ts = "";
my $inc = 0;

my @uniqs;


open BLAST, $ARGV[0] or die $!;

while(<BLAST>)
{
	chomp;
	
	(my $ts, my $scaff, my $iperc, undef, undef, undef, my $tst, my $ted, my $sst, my $sed, undef, undef) = split(/\t/);

	if($old_ts ne $ts)
	{
		$inc = 0;
		push(@uniqs, $ts);
	}
	else
	{
		$inc++;
	}

	if($sst > $sed)
	{
		$hit_reverse{$ts}[$inc] = 1;
		my $tmp = $sst;
		$sst = $sed;
		$sed = $tmp;
	}
	else
	{
		$hit_reverse{$ts}[$inc] = 0;
	}

	$hit_perc{$ts}[$inc] = $iperc;

	$bl_sc_st{$ts}[$inc] = $sst;
	$bl_sc_ed{$ts}[$inc] = $sed;

	push(@{$hit_id{$scaff}{$ts}}, $inc);

	$bl_own_st{$ts}[$inc] = $tst;

	$old_ts = $ts;
}

close BLAST;

my %outputs;
my @cr = @uniqs;

foreach(@cr)
{
	my $nam = $_;

	open my $fout, '>', $nam . "_points.txt" or die $!;

	print {$fout} "HitID" . "\t" . "Depth" . "\t" . "TsStart" . "\t" . "Perc" . "\t" . "Reverse" . "\n";

	$outputs{$nam} = $fout;
}


my @starts;
my @ends;
my @ids;
my @tss;
my @outs;
my @active;
my $activeCount = 0;
my $testCnt = 0;

my $scCnt = 0;

open WIG, $ARGV[1], or die $!;

while(<WIG>)
{
	chomp;

	my $nm = $_;

	my @sps = split(/\t/);

	my $ln = scalar @sps;

	if($ln < 2)
	{
		$scCnt++;
		@starts = ();
		@ends = ();
		@ids = ();
		@tss = ();
		@active = ();
		$activeCount = 0;
		$testCnt = 0;

		my @tst = @uniqs;

		foreach(@tst)
		{
			my $ts = $_;

			if(exists $hit_id{$nm}{$ts})
			{
				my @fids = @{$hit_id{$nm}{$ts}};

				foreach(@fids)
				{
					my $fid = $_;

					$testCnt++;

					push(@starts, $bl_sc_st{$ts}[$fid]);
					push(@ends, $bl_sc_ed{$ts}[$fid]);
					push(@ids, $fid);
					push(@outs, $outputs{$ts});
					push(@tss, $ts);
					push(@active, 0);
				}
			}
		}

		if($scCnt % 1000 == 0)
		{
			print "Checked " . $scCnt . " scaffolds so far\n";
		}
	}
	else
	{
		if($testCnt > 0)
		{
			for(my $i = 0; $i < $testCnt; $i++)
			{
				if($active[$i] == 1)
				{
					if($sps[0] >= $ends[$i])
					{
						$active[$i] = 0;
						$activeCount--;
					}
				}
				else
				{
					if($sps[0] < $ends[$i] && $sps[0] >= $starts[$i])
					{
						$active[$i] = 1;
						$activeCount++;
					}
				}
			}
		}

		if($activeCount > 0)
		{
			for(my $i = 0; $i < $testCnt; $i++)
			{
				if($active[$i] == 1)
				{
					my $fo = $outs[$i];
					my $id = $ids[$i];
					my $ts = $tss[$i];
					my $tst = $bl_own_st{$ts}[$id];
					my $rev = $hit_reverse{$ts}[$id];
					my $perc = $hit_perc{$ts}[$id];

					print {$fo} $id . "\t" . $sps[1] . "\t" . $tst . "\t" . $perc . "\t" . $rev . "\n";
				}
			}
		}
	}
}

close WIG;

my @ks = keys %outputs;

foreach(@ks)
{
	close $outputs{$_};
}




