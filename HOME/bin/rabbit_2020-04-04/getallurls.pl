#! /usr/local/bin/perl -w
# File: getallurls
# Purpose: Input is file of urls, newline delimitered, grab and write to unique file with same extension

use File::Basename;

my $gUnique = 1;

open (FILE, $ARGV[0]) || die("ERROR - can't open file \"$ARGV[1]\"");

my $gFileName;
while (<FILE>) {
	chomp($_);
	if ($_ =~ /^#/) {
		# Comment
		next;
	}
	my ($filename, $directories, $suffix) = fileparse($_);
	$suffix = $filename;
	$suffix =~ s/[^\.]+\.(.*)/$1/;
	#print STDERR "file: $_\n";
	#print STDERR "fn: $filename, dir: $directories, sufx: $suffix\n";
	$gFileName = sprintf("%03d", $gUnique) . $filename;
	$gUnique++;
	$PROXY="61.60.34.34:3128";
	print STDERR "curl -v -x $PROXY $_ > $gFileName\n";
	`curl -v -x $PROXY $_ > $gFileName`;
}