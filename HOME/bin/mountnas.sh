#!/bin/sh

server=home-nas.local
shares="backup,pictures" # Example: Comma-delimited list of shares
user=brooke
# Shouldn't need PW if have already mounted once and stored in keychain

## 🛡️ Server Reachability Check
# If the NAS isn't reachable via ping, exit 1.
# Otherwise, the osascript will pop up an unwanted dialog.
ping -c 1 "$server"
if [[ $? -ne 0 ]]; then
    echo "ping failed for server $server"
    exit 1
fi

## 🚀 Mount Shares
# Split the 'shares' string by the comma delimiter
IFS=',' read -r -a share_array <<< "$shares"

# Loop through each share name
for share in "${share_array[@]}"; do
    # Remove leading/trailing whitespace from the share name (optional, but good practice)
    share=$(echo "$share" | tr -d '[:space:]')
    
    # Skip if the share name is empty
    if [[ -z "$share" ]]; then
        continue
    fi
    
    echo "Attempting to mount share: $share"
    
    # Use osascript to check if the share is already mounted and, if not, mount it.
    osascript <<EOD
        tell application "Finder"
            # macOS mounts SMB shares under /Volumes/ShareName.
            if not (disk "$share" exists) then
                try
                    mount volume "smb://$user@$server/$share"
                on error errMsg
                    log "Failed to mount $share: " & errMsg
                end try
            else
                say "Share already mounted: $share"
            end if
        end tell
EOD
done
