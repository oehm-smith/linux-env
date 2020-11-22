# File: Tomcat.bashrc
# Created: Brooke Smith 2004 02 02
# Purpose: To set environment for Tomcat

# Note that the process is "java".

#		set -u makes it die if a varialbe is unset.
#		set +u reverses this
#			I need to use these for when Tomcat started up from a Startup script since that seems to have a 
#			"set -u" and logins bomb out (or rather, Tomcat never gets started).
#			I test if -u is set and only turn it back on (after turning off) if it was set.
#			$- contains the options that are set (ie -u)
#		

#############################################
# Deal with set +-u for non-interactive shells 
#############################################
# test if "set -u"
unset do_unset_minus_u

case "$-" in
	*u*)	
		set +u
		do_unset_minus_u=1
		;;
esac

#############################################
# Functions
#############################################
. /home2/bin/functions.profile

#############################################
# Main part
#############################################
test -r /home2/bin/java.profile && source /home2/bin/java.profile

# 20/2/2009 - TEMP COMMENT OUT as testing Jira standalone intall
export CATALINA_HOME=/usr/local/tomcat
export TOMCAT_HOME=$CATALINA_HOME
export JWSDP_HOME=$TOMCAT_HOME
export CATALINA_TMPDIR=$CATALINA_HOME/temp

#############################################
# Deal with set +-u for non-interactive shells 
#############################################
# If "set -u" before then restore it
if [ -n "$do_unset_minus_u" ]; then
	set -u
fi
