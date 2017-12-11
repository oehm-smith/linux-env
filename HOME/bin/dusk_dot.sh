#!/bin/sh
# Only works on Linux - the mac doesn't have a -h
du -sch .[!.]* * |sort -h

