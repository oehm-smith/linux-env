#!/work/bin/perl -w
# File: diffdirs.sh
# Purpose: Take two directories and run difference of each one and each sub-directory.
# Arguments:
#		$1 - directory 1 (left hand side in diff)
#		$2 - directory 2 (right hand side in diff)
# Comments:
#		Arg 2 SHOULDn'T INCLUDE A FINAL '/' as this adds one.
#		Excludes '.svn' directory
#		Doesn't print "Common subdirectory" lines from diff so only see what is different.

my $DEBUG=1;
my $PID=$$;
if ($DEBUG > 0 ) {
  $PID="nopid";
}

print "STDERR ARGV: $#ARGV\n";
if ( $#ARGV+1 < 2 ) {
  die("Usage: $0 dir1 dir2 - to get differences");
}

print STDERR "$0\n";
print STDERR "Debug: $DEBUG\n";

my $LHDIR=$ARGV[0];
my $RHDIR=$ARGV[1];

if ( ! -d $LHDIR ) {
  die("Error: LHDir aint exist - $LHDIR");
}

if ( ! -d $RHDIR ) {
  die("Error: RHDir aint exist - $RHDIR");
}

#print STDERR "LHDIR before: $LHDIR\n";
#print STDERR "RHDIR before: $RHDIR\n";
# The RHDIR may have the LHDIR in its name
# 	eg. diffdirs pubsys/tpdbpublish /work/01lib/dev/sysadmin/pubsys/tpdbpublish
#		so remove it
#	Unless 'LHDIR' is "." - that matches anything, so ignore
if ($LHDIR !~ /^\.$/) {
	$RHDIR =~ s/\/?$LHDIR//;
}
print STDERR "LHDIR: $LHDIR\n";
print STDERR "RHDIR: $RHDIR\n";
#die("testing");
my $ListOfDirs="/tmp/diffdirs_nosvnfiles.$PID";
my $DiffFile="/tmp/difffile.$PID";

if ( -e $DiffFile ) {
	unlink $DiffFile;
	`touch $DiffFile`;
}

# Debug helper - don't regenerate list if already exists
#		If have debug off (ie PID=$$) then this file should never exist
#if ( ! -e $ListOfDirs ) {
	`find $LHDIR -type d > /tmp/diffdirs_alldirs.$PID`;
	`cat /tmp/diffdirs_alldirs.$PID | grep -v ".svn" > $ListOfDirs`;
#}

print STDERR "List of dirs file: $ListOfDirs\n";

open (DIFFFILE, ">$DiffFile") || die("Error opening for write: $DiffFile");
open (DirsFILE, "$ListOfDirs") || die("Error opening for read: $ListOfDirs");
#exit 0
while (<DirsFILE>) {
	chomp;
	# $lToOutput - only if there are differences
	my $lToOutput="";
	my $lHadDiffContent = 0;
	print STDERR "$_\n";
	$lToOutput = "$_\n\n";
	#print DIFFFILE "$_\n";
	my $lDiffCmd = "diff $_ $RHDIR/$_";
	$lToOutput .= "$lDiffCmd\n";
	#print DIFFFILE "$lDiffCmd\n";
	open(DIFF,"$lDiffCmd|") || die("Error: diff - \"$lDiffCmd\"");
	while (<DIFF>) {
		# Exclude certain output
		unless (/Common subdir|svn-commit|\.bck|\.bak/) {	# 
			if ($lToOutput) {
				# Have diff output so print header
				print DIFFFILE $lToOutput;
				# Only print it once
				$lToOutput = "";	
				$lHadDiffContent=1;
			}
			print DIFFFILE "$_";
		}
	}
	if ($lHadDiffContent) {
		print DIFFFILE "==--**--====--**--====--**--====--**--==\n\n";
	}
}

print STDERR "--------------------------------------\n";
print STDERR "LHDIR: $LHDIR\n";
print STDERR "RHDIR: $RHDIR\n";
print STDERR "List of dirs file: $ListOfDirs\n";
print STDERR "Difference file: $DiffFile\n";

close DirsFILE;
close DIFFFILE;
