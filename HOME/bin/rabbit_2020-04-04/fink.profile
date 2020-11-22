#!/bin/bash
# File: fink.bashrc
# Created: Brooke Smith 2007 08 23
# set -x
# echo fink.profile - pathAppend /sw/bin
# echo PATH before: $PATH
#echo fink.profile
pathAppend /sw/bin PATH
pathAppend /sw/lib/perl5 PERL5LIB
pathAppend /sw/lib/perl5/5.8.6 PERL5LIB
pathAppend /sw/lib/perl5/5.8.6/darwin-thread-multi-2level PERL5LIB

#echo PATH after: $PATH
#test -r /sw/bin/init.sh && . /sw/bin/init.sh
