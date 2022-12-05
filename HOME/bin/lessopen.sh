#!/bin/bash

case "$1" in
  *.md)
    pandoc -s -f gfm -t man "$1" | groff -t -T utf8 -man > /tmp/less.$$
    if [ -s /tmp/less.$$ ]; then
        echo /tmp/less.$$
    else
        rm -f /tmp/less.$$
    fi
    ;;
esac
