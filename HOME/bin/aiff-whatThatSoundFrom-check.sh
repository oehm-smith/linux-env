#!/bin/bash

# Run this in a terminal to show a running continuous log of 'what made that sound'

sudo fs_usage | grep -iE "aiff"
