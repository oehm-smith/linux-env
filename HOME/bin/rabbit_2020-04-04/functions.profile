#!/bin/bash
# File: functions.profile
# Created: Brooke Smith 2007 10 21
# Purpose: To have functions to manage Paths ($MANPATH, $PATH (default), etc..) so don't get duplications
#		
# Source: http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html
#
# Comments:

# pathRemove
# 	$1 - directory
#		$2 - path variable (default is $PATH)
pathRemove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

# pathPrepend
# 	$1 - directory
#		$2 - path variable (default is $PATH)
pathPrepend () {
        pathRemove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

# pathAppend
# 	$1 - directory
#		$2 - path variable (default is $PATH)
pathAppend () {
        pathRemove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

# # source_script - to source a sub-script iff it exists
# Doesn't seem to work in that the file sourced do not go into the global Env space
#		so doing the 'test && source' calls directly now.
# function source_script() {
# 	if [ -n "$DEBUG_SHELL" ]; then 
# 		(test -r $1 && echo home.profile source $1) || echo WARN - home.profile $1 aint exist
# 		test -r $1 && source $1
# 	else
# 		(test -r $1 && source $1)
# 	fi
# }
# 
