# file: home.profile
# created: Brooke Smith 2007 10 20
# purpose: To source shell stuff to execute at startup
#		called from the .profile

#############################################
# ENVIRONMENT VARIABLES
#############################################
	# SOURCEFILEBASEDIR - where the .profile and .bashrc files are
	#		Also set in home.bashrc
# This is almost recursive since homebase sets HOMEBASE=/home2 - will need to fix up
test -r /home2/bin/homebase.bashrc && source  $SOURCEFILEBASEDIR/homebase.bashrc
export SOURCEFILEBASEDIR=$HOMEBASE/bin
export EDITOR=vi 
export PAGER='/usr/bin/less -M' 
export LANG=en_AU.UTF-8		# For Subversion (and more)
export LOADEDBINDIR=$SOURCEFILEBASEDIR/loadedbindir		# For loadbindir.profile
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# First to set functions used (called in .profile also)
. $SOURCEFILEBASEDIR/functions.profile
#############################################
# PATH
#############################################
#PATH=$PATH:/usr/local/bin:~/bin
# Making this a Prepend instead of Append so that /usr/local/bin comes before /usr/bin
pathPrepend /usr/local/bin PATH
pathAppend ~/bin PATH

#############################################
# ALIASES
#############################################
alias ls='/bin/ls -asiFG $*' 
alias l='/bin/ls -ltrhFG $*' 
alias ll='/bin/ls -lashG $*'
alias ldir='/bin/ls -ldG $**/'
alias openpreview='open -a preview $*'
#alias dusort='du -sk * | sort -n'
function dusort() {
  echo dusort prints list of size of directory in total and then size of contents of directory.
	du -s $@  | sort -r -n | awk '{sum+=$1;printf("%9d %9d %s\n",sum,$1,$2)}'
}
#############################################
# MANPATH
#############################################
#MANPATH=$MANPATH:/work/httpd/man:/work/perl/man:/usr/lib/lib/perl5/man:/usr/openwin/share/man
#MANPATH=$MANPATH:/usr/share/man:/usr/dt/share/man:/usr/demo/SOUND/man:/usr/demo/link_audit/man
#MANPATH=$MANPATH:/usr/opt/SUNWmd/man:/usr/local/perl/man:/usr/local/man:/usr/local/samba/man
#MANPATH=$MANPATH:/opt/SUNWrtvc /man:/opt/SUNWpcnfs/man:/opt/RICHPse/man:/opt/gnu/man
#MANPATH=$MANPATH:/opt/JBxv/man:/opt/schily/man:/opt/GNUfind/man:/opt/ILtin/man
#MANPATH=$MANPATH:/opt/VJtr/man:/opt/LYNX271/man 

#############################################
# LD_LIBRARY_PATH 
#		- Solaris thing, not sure of Mac thing	
#############################################
# LD_LIBRARY_PATH=/usr/local/lib:/usr/openwin/lib:$LD_LIBRARY_PATH 

#############################################
# Source other .profile files
#############################################
test -r $SOURCEFILEBASEDIR/Tomcat.profile && source $SOURCEFILEBASEDIR/Tomcat.profile
test -r $SOURCEFILEBASEDIR/java.profile && source $SOURCEFILEBASEDIR/java.profile
test -r $SOURCEFILEBASEDIR/Ant.profile && source $SOURCEFILEBASEDIR/Ant.profile
test -r $SOURCEFILEBASEDIR/Cocoon.profile && source $SOURCEFILEBASEDIR/Cocoon.profile
test -r $SOURCEFILEBASEDIR/mysql.profile && source $SOURCEFILEBASEDIR/mysql.profile
test -r $SOURCEFILEBASEDIR/OpenOffice.profile && source $SOURCEFILEBASEDIR/OpenOffice.profile
test -r $SOURCEFILEBASEDIR/Scarab.profile && source $SOURCEFILEBASEDIR/Scarab.profile
test -r $SOURCEFILEBASEDIR/Subversion.profile && source $SOURCEFILEBASEDIR/Subversion.profile
test -r $SOURCEFILEBASEDIR/JBidWatcher.profile && source $SOURCEFILEBASEDIR/JBidWatcher.profile
test -r $SOURCEFILEBASEDIR/maven.profile && source $SOURCEFILEBASEDIR/maven.profile
test -r $SOURCEFILEBASEDIR/Docbook.profile && source $SOURCEFILEBASEDIR/Docbook.profile
test -r $SOURCEFILEBASEDIR/Perl.profile && source $SOURCEFILEBASEDIR/Perl.profile
test -r $SOURCEFILEBASEDIR/fink.profile && source $SOURCEFILEBASEDIR/fink.profile
test -r $SOURCEFILEBASEDIR/cdpath.profile && source $SOURCEFILEBASEDIR/cdpath.profile
test -r $SOURCEFILEBASEDIR/foe.profile && source $SOURCEFILEBASEDIR/foe.profile

#echo PATH home.profile after fink source: $PATH
#############################################
# For all the odd bin dirs we can't afford to have
# them all in $PATH, so put sym links to $LOADEDBINDIR
#############################################
#perl $SOURCEFILEBASEDIR/loadbindir.pl

#############################################
# Export Variables
#############################################
export PATH MANPATH
#export source_script

#unset SOURCEFILEBASEDIR
#unset source_script

#echo PATH eo home.profile: $PATH
