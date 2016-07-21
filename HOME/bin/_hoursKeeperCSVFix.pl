#!/usr/bin/perl

use Switch;

# File: csiroWorkDiary2Wiki.pl
# Created: Brooke Smith 2011 03 16
# Purpose: To take a CSV output from Grindstone summary report so simple search / replace to create a wiki table with || as header cells and | as normal cells.
# Input:
#		CSV file 
# Output ('||' or '|') replace the tabs.

my $gInputFile = $ARGV[0];
my $gTool="hoursKeeperCSVFix.pl";
my $gDebug = 1;


#print STDERR "input file: $gInputFile\n";

sub parseFile() {
	my $rowNumber=0;
	my $colNumber=0;
	my @ColNames = ();
	my $lHoursTotal = 0;
	my $lAmountTotal = 0;
	my $colMax = 0;
	open(INPUT,"$gInputFile") || die("ERROR - $gTool - Can't open file for input: $gInputFile");
    while(<INPUT>) {
	    $rowNumber++;
	    $colNumber=0;
        s/\r?\n$//;
        my @line = split(/,/, $_);
        #print STDERR "Row: $rowNumber, Line: @line\n";
        foreach (@line) {
        	$colNumber++;
        	s/"//g;
        	s/\$//g;
        	#print STDERR "**";
	       	print STDERR "'$_',";
			print STDOUT "$_,";
			#print STDOUT "**";
			#print STDERR "**";
			#print STDERR "Header?  Row: $rowNumber\n";
	       	# Save the headers
	       	if ($rowNumber == 2) {	       		
	       		$ColNames[$colNumber] = $_;
	       		#print STDERR "Header: $ColNames[$colNumber-1]\n";
	       		if (/Break Time/) {     	
					print STDOUT " Break Time (H),";
				}
				if (/Worked Hours/) {     	
					print STDOUT " Worked Hours (H),";
				}
	       	} else {
				switch (lc $ColNames[$colNumber]) {
					case "worked hours" {
						if (/(\d+)h (\d+)m/) {
							my $lHours = $1 + ($2/60);
							my $lHoursRound = sprintf("%.2f", $lHours);
							$lHoursTotal += $lHours;
							#print STDOUT " (h=$1, m=$2 -> $lHours -> $lHoursRound) ";
							print STDOUT " $lHoursRound,";
						}
					}
					case "break time" {
						if (/(\d+)h (\d+)m/) {
							my $lHours = $1 + ($2/60);
							my $lHoursRound = sprintf("%.2f", $lHours);
							#$lHoursTotal += $lHours;
							#print STDOUT " (h=$1, m=$2 -> $lHours -> $lHoursRound) ";
							print STDOUT " $lHoursRound,";
						}
					}
					case "amount" {
						if (/([\d.]+)/) {
							print STDERR "AMOUNT: $1; ";
							$lAmountTotal += $1;
						}
					}
					else {
					}
					#print STDERR "XX";
				   
				
				}
			}
    	}
    	$colMax = $colNumber;
		print STDOUT "\n";
		print STDERR "\n";
    }
    # Now print the totals
	for (my $i = 1; $i <= $colMax; $i++) {
		my $val = lc $ColNames[$i];
		print STDERR "lc ColNames[$i] -> $val\n";
		if ($val =~ /worked hours/) {
    		print STDOUT ", ";	# Since I added a 'Worked Hours (H)' col
    		print STDOUT sprintf("%.2f", $lHoursTotal);
		} elsif ($val =~ /break time/) {
    		print STDOUT ", "	# Since I added a 'Break Time (H)' col
    	} elsif ($val =~ /amount/) {
    		print STDOUT sprintf("%.2f", $lAmountTotal);
    	}
    	print STDOUT ", ";
    }
}

parseFile();