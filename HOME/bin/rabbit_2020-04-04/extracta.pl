#!/usr/local/bin/perl -w
# File: extract.pl
# Purpose: to run regex on file passed as input
# Args:
#		$1 - file to parse
# Returns:
#		Output written to STDOUT
open (FILE, $ARGV[0]) || die("ERROR - can't open file \"$ARGV[1]\"");

while (<FILE>) {
	#print STDERR "$_\n";
	if ($_ =~ /.*(http:[^"'\s]+).*/) {
		print "$1\n";
	} else {
		# discard
	}
	
}
