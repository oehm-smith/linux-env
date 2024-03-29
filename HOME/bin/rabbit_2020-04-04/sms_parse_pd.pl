#!/usr/bin/perl -w

# File: sms_parse_pd.pl (Phone Director 1.06 ver of SMS')
# Created: Brooke Smith 2005 07 09
# Arguments:
#		$1 - input file which is a text file export of SMS' from Phone Director
#		$2 - out file.  JSPWiki style format will be used.

#06.07.05	07:43:23	received/read	received SMS	+61401681908	 J o   S c h o	+61411990018	Andy wants to reschedule anyway, so worked well. Fri or Sat. xx
#date\ttime\tstatus1\tstatus2\tphone number\tPhoneBookEntry or phone no\tmessage\n

package sms_parse_pd;

use Getopt::Long;
# File::Slurp;

use Iliad::debug;

my $gAppName = "sms_parse_pd";	#getFileName($0);
my $gClass = $gAppName;
my $gTempDir = "/tmp/$gAppName";

my ($gInFile, $gOutFile);

my @gSMSList = ();
my @gSMSListSorted = ();

my $gdSMSMsg = 0;


##############################################################################
# Start
##############################################################################
sub new() {
	my ($caller, %tArgs) = @_;
	
	my $class = ref($caller) || $caller;
	my $self = {};
	bless($self, $class);
	
	$self -> init();		
	return $self;
} # new

sub init() {
	&debug_new();
	&debug_fn_start($gAppName);

	if (! -d $gTempDir) {
		mkdir $gTempDir || die("ERROR - $gClass - init() - error mkdir $gTempDir");;
	}
} # init()

sub DESTROY() {
	&debug_fn_end($gAppName);
	&debug_end();
} # DESTROY()

##############################################################################
sub run() {
	my ($self) = @_;
	
	&debug_fn_start("run");

	&debug("  In: $self{INFILE}, Out: $self{OUTFILE}");
	$self -> readSMSintoList($self{INFILE}, \@gSMSList);
 	#$self -> printSMSListDebug(\@gSMSList, "SMS List before sorting");
	
	@gSMSListSorted = $self -> sortSMS(\@gSMSList);
	$self -> printSMSListDebug(\@gSMSListSorted, "SMS List after sorting");

	$self -> printSMS(\@gSMSListSorted);
	
	&debug_fn_end("run");
} # run()

# Sub: printSMSListDebug
# Purpose: SMS List contains hash data structures as entries and need to print
#		all these out.
#	Arguments:
#		$tList_ref - reference to List
# Returns:
#		NONE
sub printSMSListDebug() {
	my ($self, $tList_ref, $tDebugInfo) = @_;
	
	my $lPrintList="[$tDebugInfo] ";
	
	foreach my $lSMSDS (@$tList_ref) {
		$lPrintList .= &printHash($lSMSDS, "SMS List Entry");
	}
	&debug($lPrintList);
} # printSMSListDebug

# Sub: printSMS
# Purpose: To print out to the outfile
# 		Current plan for printing out is:
#				* Currently sorted by Person (Descending) and Date (ascending)
#	Arguments:
#		$tList_ref - reference to List
# Returns:
#		NONE, but prints to the OUTFILE
sub printSMS() {
	my ($self, $tList_ref) = @_;
	
	&debug_fn_start("printSMS");
	open (OUT, ">$self{OUTFILE}") || die("ERROR $0 - $! - Can't open file for ".
																		"writing - $self{OUTFILE}");
	foreach my $lSMSDS (@$tList_ref) {
		print OUT "!";	# Start Wiki heading
		if ($lSMSDS->{status1} =~ /stored\/unsent/) {
			print OUT "UNSENT message\n";
		} else {
			print OUT $lSMSDS->{status1};
			if ($lSMSDS->{status1} =~ /sent/) {
				print OUT " to ";
			} else {
				print OUT " from ";
			}
			print OUT "'" . $lSMSDS->{phoneBook} . "' (" . $lSMSDS->{phoneNumber} . ")\n"
		}			
		print OUT "* date: " . $lSMSDS->{date} . ", " . $lSMSDS->{time} . "\n";
		print OUT "* '" . $lSMSDS->{msg} . "'\n\n";
	}	
	close OUT;
	&debug_fn_end("printSMS");
} # printSMS()

# Sub: sortSMS()
# Purpose: To sort the SMS based on the date, using the LIST of SMS passed as input.
#		The LIST items are complete SMS'
# Args: tList_ref - array/list ref of SMS, one SMS per entry
#				tSorted_ref - return array in this array ref
# Returns: sorted array
sub sortSMS() {
	my ($self, $tList_ref) = @_;
	my @lSortList = ();

	&debug_fn_start("sortSMS");
	
	# Sub: sort_SMS
	# Purpose: To return -1, 0 or 1 to sort the SMS List
	# Comments:
	#		The SMS List contains items that are Hash Data Structures
	#			- see readSMSintoList() for details
	#		Sort by Phonebook first (was doing date then time).
	sub sort_SMS {
		my ($lDay1, $lMonth1, $lYear1);
		my ($lDay2, $lMonth2, $lYear2);
		
		#print STDERR "sort_SMS\n";

		my %lSMSEntry_A = %$b;
		my %lSMSEntry_B = %$a;

		my $lPhoneBookName1 = $lSMSEntry_A{phoneBook};
		my $lPhoneBookName2 = $lSMSEntry_B{phoneBook};
		print STDERR "  Sort $lPhoneBookName1 against $lPhoneBookName2\n";
		my $lCmpVal = $lPhoneBookName1 cmp $lPhoneBookName2;
		if ($lCmpVal) {
			#print STDERR "  returning $lCmpVal\n";
			return $lCmpVal;	# ie. not zero
		}
		#if ($lPhoneBookName1 lt $lPhoneBookName2) {
		#	return 1;
		#} elsif ($lPhoneBookName1 gt $lPhoneBookName2) {
		#	return -1;
		#}

		# If here then phonebook names (or numbers if no phonebook entry) are same
		# Sort by date (and then time below if that the same)
		my $lDate1=$lSMSEntry_A{date};
		my $lTime1=$lSMSEntry_A{time};
		#print STDERR "     date1: $lDate1\n";
		$lDate1 =~ /^([^\.]+)\.([^\.]+)\.(.*)/;
		$lDay1=$1; 
		$lMonth1=$2;
		$lYear1=$3;

		my $lDate2=$lSMSEntry_B{date};
		my $lTime2=$lSMSEntry_B{time};
		#print STDERR "     b: $b, date2: $lDate2, time: $lTime2\n";
		$lDate2 =~ /^([^\.]+)\.([^\.]+)\.(.*)/;
		$lDay2=$1; 
		$lMonth2=$2;
		$lYear2=$3;

		# For some reason, no $a or $b coming thru so need to check before continueing
		if (! $lYear1) {
			return 1;
		}
		if (! $lYear2) {
			return -1;
		}
		#print STDERR "sort_DATE: $lDay1, $lMonth1, $lYear1, ".
		#																	 "$lDay2, $lMonth2, $lYear2\n";
		
		if ($lYear1 < $lYear2) {
			return 1;
		} elsif ($lYear1 > $lYear2) {
			return -1;
		}
		# Years must be equal to be here
		if ($lMonth1 < $lMonth2) {
			return 1;
		} elsif ($lMonth1 > $lMonth2) {
			return -1;
		}
		# Months must be equal to be here
		if ($lDay1 < $lDay2) {
			return 1;
		} elsif ($lDay1 > $lDay2) {
			return -1;
		}
		# Days must be equal to be here.  Must check the time now
		my ($lSecs1, $lSecs2);
		if ($lTime1 =~ /([^:]+):([^:]+):(.*)/) {
			$lSecs1 = $1 * 3600 + $2 * 60 + $3;
		} else {
			$lSecs1 = 0;
		}
		if ($lTime2 =~ /([^:]+):([^:]+):(.*)/) {
			$lSecs2 = $1 * 3600 + $2 * 60 + $3;
		} else {
			$lSecs2 = 0;
		}
		print STDERR "   Time1: $lTime1, Secs1: $lSecs1, Time2: $lTime2, Secs2: $lSecs2\n";
		if ($lSecs1 < $lSecs2) {
			print STDERR " 1 < 2\n";
			return 1;
		} elsif ($lSecs1 > $lSecs2) {
			print STDERR " 1 > 2\n";
			return -1;
		}
		return 0;
	} # sort_SMS
	
	my @sortedArray = sort sort_SMS @$tList_ref;
	$self -> printSMSListDebug(\@sortedArray, "SMS List after sorting but in function");

	#print STDERR &printArray($tList_ref, "Before sorting");
	#print STDERR &printArray(\@sortedArray, "Sorted List");

	&debug_fn_end("sortSMS");
	return @sortedArray;
} # sortSMS()

# Sub: readSMSintoList() 
# Purpose: To read the SMS msg in given text file into LIST, one SMS per entry
# Args:
#		tSMSFile - text file containing SMS (file as exported by Phone Director)
#		tList - ref to list to populate
# Returns:
#		Nothing - tList is populated.
sub readSMSintoList() {
	my ($self, $tSMSFile, $tList_ref) = @_;
	
	&debug_fn_start("readSMSintoList");
	open (IN, $tSMSFile) || die("ERROR $! - Can't open $gInFile for reading.");

	# BS 2005 10 23 - files come in in Mac format (\r) and need to convert to Unix
	#		format (\n).

	#my $lFile = read_file($filename); # one line perl element file::slurp
	my $lFile = <IN>;
	my @lLines = split(/\r\n?/,$lFile);
	foreach my $line (@lLines) {
		# Has <nul> in there for some reason
		$line =~ s/\0//g;
		chomp $line;
		# Break into components and use create Hash as a data structure to holf
		if ($line) {
			print STDERR "Item: $line\n";
			if ($line =~ /^([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]*)\t([^\t]+)\t(.*)/)	{
				my %lSMSDataStruct=();
				$lSMSDataStruct{date}=$1;
				$lSMSDataStruct{time} = $2;
				$lSMSDataStruct{status1} = $3;
				$lSMSDataStruct{status2} = $4;
				$lSMSDataStruct{phoneNumber} = $5;
				# Allow for unsent items which won't have a phone number 
				print STDERR "\$6: '" . $6 . "', \$7: '" . $7 . "'\n";
				if (! $6 && $7 eq "-") {
					print STDERR "  \$6 bad\n";
					$lSMSDataStruct{phoneBook} = "UNSENT";
				} else {
					$lSMSDataStruct{phoneBook} = $6;
					print STDERR "  \$6: '" . $6 . "'\n";
				}				
				#$lSMSDataStruct{providerNumber} = $7;
				$lSMSDataStruct{msg} = $8;
				push (@$tList_ref, \%lSMSDataStruct);
				&debug("Add $line");
			} else {
				print STDERR "readSMSintoList() - didn't parse message $gdSMSMsg - \"$line\"\n";
				&debug("didn't parse message $gdSMSMsg - \"$line\"");
				$gdSMSMsg++;
			}
		} else {
			print STDERR "readSMSintoList() - note \$_\n";
		}
	} # foreach
	&debug_fn_end("readSMSintoList");
} # readSMSintoList

##############################################################################
## Var and options handling
sub ___________d_i_v_i_d_e_r___________() {
	# Just so it shows in the list of methods
}

# Sub: setVars_initial
# Purpose: To do any setting of variables before the options are checked
sub setVars_initial() {
	my ($self) = @_;
} # setVars_initial()

# Sub: getSwitches
# Purpose: From command-line;  set global variables
# Arguments to handle:
#		-appsubdir <eAppSubDir> 
#		[-repos <repository including svn or http, https> - DEFAULTS to Env Var $REPO]
#		-nextmajorver|-nextminorver|-nextbugfixver
#		[-nobugver]
sub getSwitches {
	my $self = $_;
	
	use vars qw($opt_infile $opt_outfile
							$opt_help $opt_man $opt_new $opt_developer $opt_x);
							
  Getopt::Long::Configure('pass_through');
  
  GetOptions("infile=s","outfile=s",
						"new!","x!","help!", "man!");

  $self{INFILE} 					=$opt_infile;
	$self{OUTFILE}					=$opt_outfile;	
	
  $self{Help}  		=$opt_help;
	$self{man}			=$opt_man;
	$self{New} 			=$opt_new;
	$self{Developer}=$opt_developer;
	$self{X} 				=$opt_x;

  my $lOther="@ARGV";
  if ($lOther) {
    print STDERR "Option(s) not supported: $lOther\n";
  }
  if ($self{Help}) {
  	print STDERR returnUsage();
  	exit 0;
  }
  if ($self{man}) {
  	$gSysCall = "perldoc $0";
  	$gRetVal = system($gSysCall);
  	if ($gRetVal != 0) {
			$gMsg="ERROR - $gClass - error calling perldoc \$0";
			&debug($gMsg);
  		die($gMsg);
  	}
  	exit 0;
  }
}	# getSwitches()

# Sub: setVars_fromOptions
# Purpose: To do any setting of variables or options from options passed.
#		You would set the outdir based on the indir here.
sub setVars_fromOptions() {
	my ($self) = @_;
} # setVars_fromOptions()

# Sub: checkVars
# Purpose: To check the vars and options that have been passed and set.
sub checkVars() {
	my ($self) = @_;
	my $lMsg;
	
	&debug_fn_start("checkVars");
	if (! $self{INFILE}) {
		$lMsg = $self -> returnUsage("infile") . "\n";
	}
	if (! -e $self{INFILE}) {
		$lMsg = $self -> returnUsage("infile '$self{INFILE}' doesn't exist.") . "\n";
	}
	if (! $self{OUTFILE}) {
		$lMsg = $self -> returnUsage("outfile") . "\n";
	}
	
	if ($lMsg) {
		&debug_comment_start();
		&debug_comment_content($lMsg);
		&debug_comment_end();
		print STDERR $lMsg;
		&debug_fn_end("checkVars");
		exit 1;
	}	
	&debug_fn_end("checkVars");
} # checkVars()

sub returnUsage {
  my ($self, $lMissing) = @_;
  my $lMesg;
  
  $lMesg = "USAGE: $0 -\n";
	$lMesg .= "\tThis is used to parse the SMS messages as written by the PhoneDirector application.\n";
	$lMesg .= "\n\tSWITCHES:\n\n";
  $lMesg .= "\t-infile <input file with SMS' from PhoneDirectory>\n";
	$lMesg .= "\t-outfile <file to write output to>\n";
	$lMesg .= "\t[-developer <dev dir name> to pick up that dev version]\n";
	$lMesg .= "\t[-X] - developer's switch.  Firstly prevents .pid extension to files\n";
	$lMesg .= "\t[-new] to force processing from start\n";
 	$lMesg .= "\t[-help to display this]\n";
 	$lMesg .= "\t[-man to display the PerlDoc manual for this file]\n";
  
  if ($lMissing) {
    $lMesg .= "\n\tMissing: $lMissing.\n";
  }
  return $lMesg;
}	# returnUsage()

sub main {
	my $lOutFile;
	
	open(CMD, ">cmd_$gAppName") || die("Cannot open cmd output file");
	print CMD "$gAppName ";
	print CMD "@ARGV";
	print CMD "\n";
	close CMD;

	my $gSMSParsePD = new sms_parse_pd();
	$gSMSParsePD -> setVars_initial();
	$gSMSParsePD -> getSwitches();
	$gSMSParsePD -> setVars_fromOptions();
	$gSMSParsePD -> checkVars();
	$gSMSParsePD -> run();
} # main()

##############################################################################
# Common main and wrapper code (just replace calls in main()
#		if a search/replace doesn't already).
##############################################################################

sub wrapper {
  eval {&main();};
  if ($@) {
    print STDERR "$0 - Died and am stopping:\n$@\n";
    exit 1;
  } 
  exit 0;
}

&wrapper();