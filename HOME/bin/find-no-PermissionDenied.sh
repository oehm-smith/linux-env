#!/usr/bin/env bash

# Use this to find but not see the 'Permission Denied' error that excludes seeing the output
# Args: What one is looking for.  If contains a wildcard, wrap in quotes
# eg. find-perm.... "webapp*"

find . -name "$1" 2>&1 | grep -v 'Permission denied' >&2

