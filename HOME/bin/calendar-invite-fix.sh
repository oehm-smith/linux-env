#!/bin/bash
# ABOUTME: Fixes ICS files exported from Thunderbird so they open in macOS Calendar.
# ABOUTME: Thunderbird saves accepted invites as METHOD:REPLY (RSVP) instead of METHOD:REQUEST (event), and Exchange/Outlook invites use Windows timezone IDs that macOS doesn't recognise.

set -euo pipefail

INPUT="${1:-/tmp/invite.ics}"
FIXED="${INPUT%.ics}-fixed.ics"

if [[ ! -f "$INPUT" ]]; then
    echo "Error: $INPUT not found" >&2
    exit 1
fi

# Check for Windows timezone IDs we know how to fix
KNOWN_TZ_PATTERN="AUS Eastern (Standard|Daylight) Time"
if grep -qP "TZID[=:].*(?!Australia/)" "$INPUT" 2>/dev/null; then
    if ! grep -qP "$KNOWN_TZ_PATTERN" "$INPUT"; then
        echo "⚠️  WARNING: Unrecognised Windows timezone ID found:" >&2
        grep -oP 'TZID[=:]\K[^;:]+' "$INPUT" | sort -u | grep -v "Australia/" >&2
        echo "⚠️  The time may be WRONG — check the event time or you'll be late/early to the meeting!" >&2
        echo "" >&2
    fi
fi

sed -e 's/METHOD:REPLY/METHOD:REQUEST/' \
    -e 's/AUS Eastern Standard Time/Australia\/Sydney/g' \
    -e 's/AUS Eastern Daylight Time/Australia\/Sydney/g' \
    "$INPUT" > "$FIXED"

echo "Fixed: $FIXED"
open "$FIXED"
