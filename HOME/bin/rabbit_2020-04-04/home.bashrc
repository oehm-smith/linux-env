# file: home.bashrc
# created: Brooke Smith 2004 02 02
# purpose: To do home related shell startup stuff
#echo home.bashrc

#############################################
# Environment variables
#############################################
	# SOURCEFILEBASEDIR - where the .profile and .bashrc files are
	#		Also set in home.bashrc
export SOURCEFILEBASEDIR=/home2/bin

#############################################
# Alias
#############################################
alias source_script2='echo ss2 $* && test -r $* && source $*'

#############################################
# Functions
#############################################
# First to set functions used (called in .profile also)
. $SOURCEFILEBASEDIR/functions.profile


#############################################
# Other configurations
#############################################
	# Exclude all other users in the permissions
umask 007 
  # Set bash to use vi-style editing
set -o vi 
  # limit cores to 0b 
ulimit -c 0 
	# Set the DISPLAY
export DISPLAY=:0

# Setup the PS variables 
# Setup a red prompt for root and a green one for users. 
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
BLUE="\[\e[1;34m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$BLUE\u$RED@\h $NORMAL\W$RED \$ $NORMAL"
fi

# PS1='\\u@\\h `basename $PWD` $PROMPT_CHAR ' 
#export PS1='$LOGNAME@hera `basename $PWD` $PROMPT_CHAR ' 
#PS1="\[\033[34m\]\[\033]0;\W \h:$PWD\007\u@\h \W $PROMPT_CHAR \[\033[30m\]"
#export PS1='\[\033[34m\]\[\033]0;\W \h:$PWD\007\u@\h \w \t \n\$ \[\033[30m\]' 
#export PS1="\[\e[34;1m\]\u@\h \[\e[31;1m\]\W \$ \[\e[0m\]"
 
#PROMPT_COMMAND='PWDF=`pwd|sed "s/.*\/\(.*\)/\1/"`; echo -ne "\033]0;$TTY:${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007\033] 30;${HOSTNAME%%.*}:${PWDF}\007"'


#############################################
# PATH
#############################################


#############################################
# Source other shell files
#############################################
#function source_script() {
#	test -f $1 && source $1
#}

# Both a function "source_script" or an alis didn't seem to work.
# This homebase.bashrc script just contains one or a few variables necesssary for Startup scripts and scripts sourced below
test -r $SOURCEFILEBASEDIR/homebase.bashrc && source  $SOURCEFILEBASEDIR/homebase.bashrc
test -r $SOURCEFILEBASEDIR/Tomcat.bashrc && source  $SOURCEFILEBASEDIR/Tomcat.bashrc
test -r $SOURCEFILEBASEDIR/java.bashrc && source $SOURCEFILEBASEDIR/java.bashrc
test -r $SOURCEFILEBASEDIR/Ant.bashrc && source $SOURCEFILEBASEDIR/Ant.bashrc
test -r $SOURCEFILEBASEDIR/Cocoon.bashrc && source $SOURCEFILEBASEDIR/Cocoon.bashrc
test -r $SOURCEFILEBASEDIR/MySQL.bashrc && source $SOURCEFILEBASEDIR/MySQL.bashrc
test -r $SOURCEFILEBASEDIR/OpenOffice.bashrc && source $SOURCEFILEBASEDIR/OpenOffice.bashrc
test -r $SOURCEFILEBASEDIR/Scarab.bashrc && source $SOURCEFILEBASEDIR/Scarab.bashrc
test -r $SOURCEFILEBASEDIR/Subversion.bashrc && source $SOURCEFILEBASEDIR/Subversion.bashrc
test -r $SOURCEFILEBASEDIR/JBidWatcher.bashrc && source $SOURCEFILEBASEDIR/JBidWatcher.bashrc
test -r $SOURCEFILEBASEDIR/fink.bashrc && source $SOURCEFILEBASEDIR/fink.bashrc
test -r $SOURCEFILEBASEDIR/maven.bashrc && source $SOURCEFILEBASEDIR/maven.bashrc

#############################################
# EXPORT VARS
#############################################
export PS1
