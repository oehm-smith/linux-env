#!/bin/bash
# pingtest.sh - do pings to test home wireless network connection
# Use timeout of 4 seconds, send 2 pings
TIMEOUT=10
COUNT=2
ROUTER=192.168.1.1
MODEM=192.168.1.1
#SITE_DNS=google-public-dns-a.google.com
SITE_DNS=google.com
SITE_IP=8.8.8.8
PING=/sbin/ping

echo Run pingtest 
echo TEST 1 - Can we reach the wireless router?
echo ping -t $TIMEOUT -c $COUNT $ROUTER
$PING -t $TIMEOUT -c $COUNT $ROUTER
res=$?
if [ $res -ne 0 ]; then
	echo =======================================
	echo ping failed
	echo =======================================
	exit 1
else
	echo =======================================
	echo ping successful
	echo =======================================
fi

echo TEST 2 - Can we reach the modem?
echo ping -t $TIMEOUT -c $COUNT $MODEM
$PING -t $TIMEOUT -c $COUNT $MODEM
res=$?
if [ $res -ne 0 ]; then
	echo =======================================
	echo ping failed
	echo =======================================
	exit 1
else
	echo =======================================
	echo ping successful
	echo =======================================
fi

echo TEST 3 - Can we reach an internet IP address?
echo ping -t $TIMEOUT -c $COUNT $SITE_IP
$PING -t $TIMEOUT -c $COUNT $SITE_IP
res=$?
if [ $res -ne 0 ]; then
	echo =======================================
	echo ping failed
	echo =======================================
	exit 1
else
	echo =======================================
	echo ping successful
	echo =======================================
fi

echo TEST 1 - Can we reach the same site with its domain name [test DNS]?
echo ping -t $TIMEOUT -c $COUNT $SITE_DNS
$PING -t $TIMEOUT -c $COUNT $SITE_DNS
res=$?
if [ $res -ne 0 ]; then
	echo =======================================
	echo ping failed
	echo =======================================
	exit 1
else
	echo =======================================
	echo ping successful
	echo =======================================
fi
