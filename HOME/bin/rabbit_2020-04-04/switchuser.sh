#!/bin/sh
# switchuser
# From http://www.macosxhints.com/article.php?story=20031102031045417&query=
# Used to switch to another user or show login screen if no argument given
# ARGS: <user> or nothing to goto login screen.

if [[ -z $1 ]]; then
  # robg note: Please enter the next two lines as one without
  # any spaces between the "/" and the "R"
  /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
else
  USERID=`id -u $1`;
  if [[ -z $USERID ]]; then
    exit -1;
  fi;
  # robg note: Please enter the next two lines as one without
  # any spaces between the "/" and the "R"
  /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -switchToUserID $USERID
fi;
