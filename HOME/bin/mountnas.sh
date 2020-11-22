#!/bin/sh

server=home-nas.local
share=common
user=brooke
# Shouldn't need PW if have already mounted once and stored in keychain

# If the NAS isn't reachable via ping, exit 1.
# Otherwise, the osascript will pop up an unwanted dialog.
ping -c 1 $server
if [[ $? -ne 0 ]]; then
    echo "ping failed for server $server"
    exit 1
fi

osascript <<EOD
	tell application "Finder"
	if not (disk "$share" exists) then
		mount volume "smb://$user@$server/$share"
	else
		say "Share already mounted: $share"
	end if
	end tell
EOD

