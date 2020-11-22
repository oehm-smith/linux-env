#!/usr/bin/perl -w
# This is used to get diagnostics on a modem connection dropping out.  It:
# * Assumption: Modem is working and its admin page can be reached
# * Finds the IP address my ISP provides
# * Pings an external site with a count of 1 and records if the packets are received or not
# * Time printed out with this

use WWW::Curl::Easy;
use Net::Ping;
use File::Path;
use IO::File;

my $gModemIP = "10.1.1.1";
my $gModemPage = "http://$gModemIP/MainPage?id=32";
my $gHostToPing = "speedtest.net";
my $gLastIP;	# If the IP changes print it out
my $gPingStage; # If changes then print so
my $gLOGHANDLE; # Handle to write log to
my $gPingTO = 5; # Ping timeout

# Returns IP address ISP provides
sub getIPAddress() {
	my $curl = new WWW::Curl::Easy;
	my $lIP="";

	#print STDERR "Curl $gModemPage\n";
	$curl->setopt(CURLOPT_URL, $gModemPage);
	my $response_body;

	# NOTE - do not use a typeglob here. A reference to a typeglob is okay though.
	open (my $fileb, ">", \$response_body);
	$curl->setopt(CURLOPT_WRITEDATA,$fileb);

	# Starts the actual request
	my $retcode = $curl->perform;

	# Looking at the results...
	if ($retcode == 0) {
		#print("Transfer went ok\n");
		my $response_code = $curl->getinfo(CURLINFO_HTTP_CODE);
		# judge result and next action based on $response_code
		#print("Received response: $response_body\n");
		if ($response_body =~ /(IP Address).*value="([0-9]*\.[0-9]*\.[0-9]*\.[0-9]*)"/i) {
			#print STDERR "$1 = $2\n";
			$lIP = $2;
		}
	} else {
		print("An error happened: ".$curl->strerror($retcode)." ($retcode)\n");
	}
	return $lIP;
}

# Sub: ping
# This sets the gPingStage to the stage ('alive', 'dead') and returns an appropriage message if it changed
#		and nothing "" if it hasn't changed.
sub ping() {
	my $lRetMsg="";
	my $p = Net::Ping->new();
	
	if ($p->ping($gHostToPing, $gPingTO)) {
		if (!$gPingStage || $gPingStage !~ /alive/) {
			$lRetMsg = "$gHostToPing is alive.";
			$gPingStage = "alive";
		}
	} else {
		#print STDERR "Ping is dead.\n";
		if (!$gPingStage || $gPingStage !~ /dead/) {
			$lRetMsg = "$gHostToPing is dead.";
			$gPingStage = "dead";
		}
	}
	$p->close();
	#print STDERR "ping - retmsg: $lRetMsg, stage: $gPingStage\n";
	return $lRetMsg;
}

sub mydate() {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime();
	$year+=1900;
	$mon++;
	return sprintf("%04d", $year).".".sprintf("%02d", $mon).".".sprintf("%02d", $mday)."+".
					sprintf("%02d", $hour)."_".sprintf("%02d", $min)."_".sprintf("%02d", $sec);
}

sub mytime() {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime();
	return sprintf("%02d", $hour).":".sprintf("%02d", $min).":".sprintf("%02d", $sec);
}

sub ipchanges() {
	my $lNewIP = shift;
	
	#print STDERR "ipchanges() -\nNew: $lNewIP\nOld: $gLastIP";
	if (! $gLastIP || $gLastIP !~ $lNewIP) {
		#print STDERR " - changed\n";
		return 1;
	}
	#print STDERR " - fls \n";
	return 0;
}

sub openlogfile() {
	my $lBase = "/Users/bsmith/tmp/modemnetworktestlogs";
	if (! -d $lBase) {
		mkpath([$lBase],1, oct("0777")) || die("ERROR mkdir $lBase, oct(0777)");
	}
	if (! -d $lBase) {
		die("ERROR - base should have been made: $lBase");
	}
	my $lTime = &mydate();
	my $lFile = $lBase . "/${lTime}.log";
	
	print STDERR "Logfile to create: $lFile\n";# (lBase:$lBase, lTime:$lTime)\n";
	$gLOGHANDLE = new IO::File;
	if ($gLOGHANDLE->open("> $lFile")) {
	#		&writeToLogfile("Hello\n");
	#		#$gLOGHANDLE->close;
	} else {
		die("filehandle didn't open");
	}

	#local *FH;
	#open(FH, ">$lFile") || die("ERROR - opening logfile for writing: $lFile");
	#$gLOGHANDLE = *FH;
	#print $gLOGHANDLE "Testing logfile.\n";
	#close $gLOGHANDLE;
	#die("testing logfile");
}

sub closelogfile() {
	print STDERR "Close logfile.\n";
	$gLOGHANDLE->close;
}

sub writeToLogfile() {
	my $lMsg = shift;
	
	print STDERR "$lMsg\n";
	$gLOGHANDLE->write($lMsg."\n");
}
	
sub DESTROY() {
	print STDERR "DESTROY\n";
	&closelogfile();
}

sub main() {
	my $done=0;
	&openlogfile();
	while (1) {
		my $lPingMsg = &ping();
		if ($lPingMsg) {
			&writeToLogfile("----------------------------------------");
			&writeToLogfile("Time: " . mytime());
			my $lIP = getIPAddress();
			if (&ipchanges($lIP)) {
				$gLastIP = $lIP;
				&writeToLogfile("************* IP CHANGED ****************");
				&writeToLogfile("* $lIP");
			}
			#ping();
			&writeToLogfile($lPingMsg);
			#&writeToLogfile("farg\n");
			#die("testing logfile");
			sleep 2;
		}
		#&writeToLogfile("farg 2\n");
		#if ($done > 3) {
		#	&writeToLogfile("---------test -------------------------------\n");
			#die("testing logfile") ;
		#}
		#die("testing logfile");
		#$done++;
		$gLOGHANDLE -> flush();
		$gLOGHANDLE -> sync();
	}
	&closelogfile();
}

main();
