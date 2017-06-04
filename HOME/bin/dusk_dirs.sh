#!/bin/sh
# Sort dirs in . by size.  Human readable format.
#
du -hs * |   awk '{printf "%s %08.2f\t%s\n",
    index("KMG", substr($1, length($1))),
    substr($1, 0, length($1)-1), $0}' |   sort -r | cut -f2,3
