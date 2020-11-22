#!/usr/local/bin/perl

use Net::Ping;
    
# Program to ping all addresses in ranges:
#		10.0.0.0 	10.255.255.255
# 	172.16.0.0 	172.31.255.255
#		192.168.0.0 	192.168.255.255

#		10.0.0.0 	10.255.255.255
my ($a,$b,$c)=0;
my $gIP;
my @gReachableIPs = ();
$p = Net::Ping->new("icmp",0.00003);
for ($a=0;$a<256;$a++) {
	for ($b=0;$b<256;$b++) {
		for ($c=0;$c<256;$c++) {
			$gIP="10.$a.$b.$c";
			print STDERR "ping $gIP\n";
			$p->ping($gIP);
	   	my ($lRet, $lDuration, $lIP) = $p->ping($gIP);
	   	if ($lRet) {
	 			printf("$host [ip: $lIP] is alive (packet return time: %.2f ms)\n", 1000 * $lDuration);
 				push(@gReachableIPs,$gIP);
 			}
			#open (PING,"/sbin/ping 10.$a.$b.$c |") || die;
			#while (<PING>) {
			#	print "->$_\n";
			#}
		}
	}
}
$p->close();
print STDERR "Reachable IPs:\n";
foreach my $lItem (@gReachableIPs) {
	print STDERR "  $lItem\n";
}