#!/usr/bin/perl -w
# File: WikiMonthMaker.pl
# created: Brooke Smith 2004 09 01
# Purpose: To write a text file for the Diary days in the given month &
# 	year that will be used as WIki links to the days so a diary 
#		entry can be made.

# Arg 0 - month, Arg 1 - year

my ($gMonth, $gYear);

$gMonth = $ARGV[0];
$gYear = $ARGV[1];

my $gDEBUG=1;

if (! $gMonth) {
	#die("Month expected.\n" . usage());
	$gMonth = 9;
}

if (! $gYear) {
	#die("Year expected.\n" . usage());
	$gYear = 2004;
}

sub usage() {
    return "$0 -\nGenerate text file of Days in month for Wiki diary page.\n" .
        "Usage:\n" .
        "  $1 - Month\n" .
        "  $2 - Year\n";
} # usage

sub init() {
#	print STDERR "init()\n";
}

sub run() {
	if ($gDEBUG ge 1) {
		print STDERR "-> run()\n";
	}
	if ($gDEBUG ge 1) {
		print STDERR "   month: $gMonth, year: $gYear - get the cal data\n";
	}
	my %lCal = getCal($gMonth, $gYear);
#	print STDERR "Cal $gMonth $gYear - print cal data\n";
	#fPrintHash(\%lCal, "Cal in run()");
#	print STDERR "Print the cal hash manually.\n";
#	foreach my $lKey (keys %lCal) {
#		print STDERR "$lKey -> " . $lCal{$lKey} . "\n";
#	}
	
	my (@lSun,@lMon,@lTue,@lWed,@lThur,@lFri,@lSat) =
			((),(),(),(),(),(),());
	my $lNumDays = 0;

#	print STDERR "Wed array in run(): " . \@lWed . "\n";
	breakUpCal(\%lCal,\@lSun,\@lMon,\@lTue,\@lWed,\@lThur,\@lFri,\@lSat,$lNumDays);

	if ($gDEBUG ge 1) {
		fPrintArray(\@lSun, "SUN at end");
		fPrintArray(\@lMon, "MON at end");
		fPrintArray(\@lTue, "TUE at end");
		fPrintArray(\@lWed, "WED at end");
		fPrintArray(\@lThur, "THUR at end");
		fPrintArray(\@lFri, "FRI at end");
		fPrintArray(\@lSat, "SAT at end");
		fPrintHash(\%lCal, "Cal");
	}
	my %lMonthHash = fDayArraysToMonthHash(\@lSun,\@lMon,\@lTue,\@lWed,\@lThur,\@lFri,\@lSat);
	fPrintWikiMonth(\%lMonthHash);
#	print STDERR "Num of days: $lNumDays Sun days: ";
	#fPrintArray(\@lSun, "SUN in run()");
	if ($gDEBUG ge 1) {
		print STDERR "<- run()\n";
	}
} # run()

sub getCal() {
	my ($lMonth, $lYear) = @_;
	my %lCal = ();
	my $lDaysRow = 1;
	
	open(CAL, "cal $lMonth $lYear |");
	while (<CAL>) {
		if ($gDEBUG ge 1) {
			print STDERR "parse: $_";
		}
		if (/\W+([A-Z][a-z]+) +(\d+).*/) {
			$gMonth = $1;
			$gYear = $2;
			if ($gDEBUG ge 1) {
				print STDERR "Month: $gMonth, Year: $gYear\n";
			}
			$lCal{MONTH}=$1;
			$lCal{YEAR}=$2;
		}
		if (/( S  M Tu  W Th  F  S)/) {
			if ($gDEBUG ge 1) {
				print STDERR "Sun - Sat\n";
			}
			$lCal{SUN2SAT}=$1;
		}
		if (/^([ \d]+)$/) {
			if ($gDEBUG ge 1) {
				print STDERR "days: $1\n";
			}
			$lCal{ROW.$lDaysRow}=$1;
			$lDaysRow++;
		}
	}
	return %lCal;
} # getCal()

# sub: breakUpCal
# purpose: to take the hash derived from the cal and break out info
# input: $tCal - addr. of hash representation of cal
#				 $tSun -> $tSat - addr. of arrays where to write results
#						Each of these will contain the number of the days in the
#						month that falls on that day.
#				 $tNumDays - Scalar to return number of days in month.
sub breakUpCal() {
	# Addresses of input cal, and arrays to output results in
	my ($tCal, $tSun,$tMon,$tTue,$tWed,$tThur,$tFri,$tSat,$tNumDays) = @_;

	my %lCal;
	#, @lSun,@lMon,@lTue,@lWed,@lThur,@lFri,@lSat);
	
	if ($gDEBUG ge 1) {
		print STDERR "-> breakUpCal()\n";
	}
	
#	@lWed = @{$tWed};
##	push(@lWed, "poo");
##	push(@lWed, "nit");
##	fPrintArray(\@lWed, "Wed in breakUpCal()");
##	print STDERR "tWed: $tWed\n";
##	print STDERR "lWed: " . \@lWed . "\n";
##	print STDERR "Try print out array directly in breakupcall() - $tWed\n";
##	foreach my $larr (@lWed) {
##		print STDERR "$larr ";
##	}
##	print STDERR "\n";
##	# Actual Hash and Arrays.
	
	%lCal = %$tCal;
	if ($gDEBUG ge 1) {
		fPrintHash($tCal, "Cal in breakUpCal()");
	}
#	print STDERR "Can I print cal in breakupCal()?\n";
#	foreach my $lKey (keys %lCal) {
#		print STDERR "$lKey -> " . $lCal{$lKey} . "\n";
#	}
	
#	@lSun = @{$tSun};
#	@lMon = @{$tMon};
#	@lTue = @{$tTue};
#	@lWed = @{$tWed};
#	@lThur= @{$tThur};
#	@lFri = @{$tFri};
#	@lSat = @{$tSat};
	
	my %lDaysInRow = ();
	%lDaysInRow = getDaysInRow($lCal{ROW1});
	CopyDays(\%lDaysInRow, $tSun, $tMon, $tTue, $tWed, $tThur, $tFri, $tSat);
	if ($gDEBUG ge 2) {
		fPrintHash(\%lDaysInRow,"Days in Row 1");
		fPrintArray(\@$tSun, "SUN after Copy Row 1");
	}
	%lDaysInRow = getDaysInRow($lCal{ROW2});
	CopyDays(\%lDaysInRow, $tSun, $tMon, $tTue, $tWed, $tThur, $tFri, $tSat);
	if ($gDEBUG ge 2) {
		fPrintHash(\%lDaysInRow,"Days in Row 1");
		fPrintArray(\@$tSun, "SUN after Copy Row 2");
	}
	%lDaysInRow = getDaysInRow($lCal{ROW3});
	CopyDays(\%lDaysInRow, $tSun, $tMon, $tTue, $tWed, $tThur, $tFri, $tSat);
	if ($gDEBUG ge 2) {
		fPrintHash(\%lDaysInRow,"Days in Row 1");
		fPrintArray(\@$tSun, "SUN after Copy Row 3");
	}
	%lDaysInRow = getDaysInRow($lCal{ROW4});
	CopyDays(\%lDaysInRow, $tSun, $tMon, $tTue, $tWed, $tThur, $tFri, $tSat);
	if ($gDEBUG ge 2) {
		fPrintHash(\%lDaysInRow,"Days in Row 1");
		fPrintArray(\@$tSun, "SUN after Copy Row 4");
	}
	%lDaysInRow = getDaysInRow($lCal{ROW5});
	CopyDays(\%lDaysInRow, $tSun, $tMon, $tTue, $tWed, $tThur, $tFri, $tSat);
	if ($gDEBUG ge 2) {
		fPrintHash(\%lDaysInRow,"Days in Row 5");	
		fPrintArray(\@$tSun, "SUN after Copy Row 5");
	}
	if ($gDEBUG ge 1) {
		print STDERR "<- breakUpCal()\n";
	}
} # breakUpCal()

@gDays = ('SUN','MON', 'TUE', 'WED', 'THUR', 'FRI', 'SAT');

# sub: getDaysInRow
# purpose: To return the week from the row from cal. For those days 'missing'
#		in the row the entry will be ''. Returns in hash with keys 'SUN' -> 'SAT'.
# input: $tRow - row from cal
# output: Hash with keys SUN, MON, TUE, WED, THUR, FRI, SAT
sub getDaysInRow() {
	my ($tRow)	= @_;
	my %tDaysOfWeek = ();
	
	if ($gDEBUG ge 1) {
		print STDERR "-> getDaysInRow()\n";
	}
	# Determine the number of blank days at the beginning, the number of days and
	#	then the number of blank days at the end.
	my ($lBegBlanks, $lMidDays, $lEndBlanks, 
			$lNumBegBlankDays, $lNumDays);
	
	if ($tRow =~ /^( *)((( \d ?)|(\d\d ?))+)( *)$/) {
		$lBegBlanks = $1;
		$lMidDays = 	$2;
		$lEndBlanks = $6;
	}
	$lNumBegBlankDays = (length($lBegBlanks)/3);
	$lNumDays = ((length($lMidDays)+1)/3); # +1 since it missing ' ' at end.
	if ($gDEBUG ge 2) {
		print STDERR "     \"$lBegBlanks|$lMidDays|$lEndBlanks\" - $lNumBegBlankDays, $lNumDays\n";
	}
	
	# Break out the days into an array
	# Remove any leading ' ' first
	$lMidDays =~ s/ *(.*)/$1/;
	my @lDaysArray = split(/ +/, $lMidDays);

	# The first $lNumBegBlankDays days are set to ''
	my $i=0;
	#my $j=0;
	my $index;
	for ($i=0; $i<$lNumBegBlankDays; $i++) {
		if ($gDEBUG ge 2) {
			print STDERR "     Set tDaysOfWeek{$gDays[$i]} (index $i) to ''\n";
		}
		#$tDaysOfWeek{$gDays[$i]} = "";
	}

	# The next $lNumDays are set to @lDaysArray[i]
	for ($i=0;$i<$lNumDays;$i++) {
		$index = $lNumBegBlankDays + $i;
		if ($gDEBUG ge 2) {
			print STDERR "     Set tDaysOfWeek{$gDays[$index]} (index $index) to $lDaysArray[$i]\n";
		}
		$tDaysOfWeek{$gDays[$index]} = $lDaysArray[$i];
	}
	
	# The last (7 - $lNumBegBlankDays - $lNumDays) are set to ''
	for ($i=0; $i<(7 - $lNumBegBlankDays - $lNumDays); $i++) {
		$index = $lNumBegBlankDays + $lNumDays + $i;
		if ($gDEBUG ge 2) {
			print STDERR "     Set tDaysOfWeek{$gDays[$index]} (index $index) to ''\n";
		}
		#$tDaysOfWeek{$gDays[$index]} = "";
	}
	
#	print STDERR "DaysOfWeek hash:\n";
#	foreach my $lDay (keys %tDaysOfWeek) {
#		print STDERR "  $lDay -> $tDaysOfWeek{$lDay}\n";
#	}
	if ($gDEBUG ge 1) {
		print STDERR "<- getDaysInRow()\n";
	}
	return %tDaysOfWeek;
} # getDaysInRow()

# sub: CopyDays
# purpose: To copy the days information in tDaysInRow (one row from cal)
#		to the days hashes.
# arguments:
#		tDaysInRow - addr of hash that contains the days from a row in cal
#		tSun - $tSat - addr of arrays to populate
sub CopyDays() {
	my ($tDaysInRow, $tSun, $tMon, $tTue, $tWed, $tThur, $tFri, $tSat) = @_;
	
	my %lDaysInRow = %$tDaysInRow;

	if ($gDEBUG ge 1) {
		print STDERR "-> CopyDays()\n";
	}
#	fPrintHash($tDaysInRow, "Days In Row (CopyDays())");

	if ($lDaysInRow{SUN}) {
		push(@$tSun, $lDaysInRow{SUN});
	}
	if ($lDaysInRow{MON}) {
		push(@$tMon, $lDaysInRow{MON});
	}
	if ($lDaysInRow{TUE}) {
		push(@$tTue, $lDaysInRow{TUE});
	}
	if ($lDaysInRow{WED}) {
#		print STDERR "Added wed to array: $lDaysInRow{WED}\n";
		push(@$tWed, $lDaysInRow{WED});
	}
	if ($lDaysInRow{THUR}) {
		push(@$tThur, $lDaysInRow{THUR});
	}
	if ($lDaysInRow{FRI}) {
		push(@$tFri, $lDaysInRow{FRI});
	}
	if ($lDaysInRow{SAT}) {
		push(@$tSat, $lDaysInRow{SAT});
	}
	
	#fPrintArray(\@$tWed, "Wed in copydays");
	if ($gDEBUG ge 1) {
		print STDERR "<- CopyDays()\n";
	}
} # CopyDays()

# sub: fDayArraysToMonthHash
# purpose: To take arrays for SUN -> SAT and produce hash out of it
# input: Day Arrays (SUN - SAT)
#	returns: Hash - key is day of month (1 .. 28, 29, 30 or 31)
#									value is Sunday to Saturday.
sub fDayArraysToMonthHash() {
	my ($tSun,$tMon,$tTue,$tWed,$tThur,$tFri,$tSat) = @_;
	my %lMonth = ();
	
	my $lDay;
	
	foreach $lDay (@$tSun) {
		$lMonth{$lDay}="Sunday";
	}
	foreach $lDay (@$tMon) {
		$lMonth{$lDay}="Monday";
	}
	foreach $lDay (@$tTue) {
		$lMonth{$lDay}="Tuesday";
	}
	foreach $lDay (@$tWed) {
		$lMonth{$lDay}="Wednesday";
	}
	foreach $lDay (@$tThur) {
		$lMonth{$lDay}="Thursday";
	}
	foreach $lDay (@$tFri) {
		$lMonth{$lDay}="Friday";
	}
	foreach $lDay (@$tSat) {
		$lMonth{$lDay}="Saturday";
	}
	return %lMonth;
} # fDayArraysToMonthHash()

# sub: fPrintWikiMonth
# purpose: We have the days with the numbers they fall on in hash and so print out
#		page with the dates in Wiki style.
# input: $tMonthHash - hash that maps day of month (1..28, 29, 30 or 31) to
#				Day of week (Sunday - Saturday).
# returns: NOTHING, but outputs information.
sub fPrintWikiMonth() {
	my ($tMonth) = @_;
	
	my %lMonth = %$tMonth;
	
	if ($gDEBUG ge 1) {
		print STDERR "-> fPrintWikiMonth()\n";
	}
	if ($gDEBUG ge 1) {
		fPrintHash($tMonth, "Month Hash");
	}

	print STDOUT "!!!Diary $gMonth $gYear\n\n";
	for (my $i=1;$i<=31;$i++) {
		if ($lMonth{$i}) {
			print STDOUT "[$lMonth{$i} $i";
			if ($i eq 1 or $i eq 21 or $i eq 31) {
				print STDOUT "st";
			} elsif ($i eq 2 or $i eq 22) {
				print STDOUT "nd";
			} elsif ($i eq 3 or $i eq 23) {
				print STDOUT "rd";
			} else {
				print STDOUT "th";
			}
			print STDOUT " $gMonth $gYear|";
			print STDOUT sprintf("%02d", $i);
			print STDOUT " $gMonth $gYear]\\\\\n";
			if ($lMonth{$i} =~ /Sunday/i) {
				print STDOUT "----\n";
			}
		}
	} # for loop
	if ($gDEBUG ge 1) {
		print STDERR "<- fPrintWikiMonth()\n";
	}
} # fPrintWikiMonth()

############################################################

sub fPrintArray() {
	my ($tArray, $tArrayMsg) = @_;
	my @lArray = @${tArray};
	print STDERR "Print Array ($tArrayMsg) - $tArray : \n";
	foreach my $lArr (@{$tArray}) {
		print STDERR "  $lArr\n";
	}
} # fPrintArray

sub fPrintHash() {
	my ($tHash, $tHashMsg) = @_;
	my %lHash = %{$tHash};
	
	print STDERR "Print Hash ($tHashMsg) - $tHash: \n";
	foreach my $lKey (keys %{$tHash}) {
		print STDERR "  $lKey -> " . ${%{$tHash}}{$lKey} . "\n";
	}
} # fPrintHash

sub main() {
	init();
	run();
	if ($@) {
		die("$0 died with $@");
	}
}

main();