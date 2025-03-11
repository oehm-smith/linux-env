#!/bin/sh
# Use to write a list of the original files for alias to $2
# Then can do this to copy orignals somewhere (go to there):
#	$ SAVEIFS=$IFS
#	$ IFS=$(echo -en "\n\b")
#	$ for i in $(cat originals.txt )
#        do
#          echo $i
#          cp "$i" .
#        done
# ... And more - I wrote "cpOriginals.sh"
if [ $# -lt 2 ]; then
  echo ""
  echo "Usage: $0 alias outfile"
  echo "  where alias is an alias file."
  echo "  where outfile is name to write file name of origina to."
  echo "  Returns the file path to the original file referenced by a"
  echo "  Mac OS X GUI alias.  Use it to execute commands on the"
  echo "  referenced file.  For example, if aliasd is an alias of"
  echo "  a directory, entering"
  echo '   % cd `apath aliasd`'
  echo "  at the command line prompt would change the working directory"
  echo "  to the original directory."
  echo ""
  exit 1
fi
if [ -f "$1" -a ! -L "$1" ]; then
    # Redirect stderr to dev null to suppress OSA environment errors
    exec 6>&2 # Link file descriptor 6 with stderr so we can restore stderr later
    exec 2>/dev/null # stderr replaced by /dev/null
    path=$(osascript << EOF
tell application "Finder"
set theItem to (POSIX file "${1}") as alias
if the kind of theItem is "alias" then
get the posix path of ((original item of theItem) as text)
end if
end tell
EOF
)
    exec 2>&6 6>&-      # Restore stderr and close file descriptor #6.

    echo "$path" >> $2
fi

