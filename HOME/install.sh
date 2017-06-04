#!/usr/bin/env bash

# Install these files into current users home
# Any existing files are renamed with a unique date extension

d=$(date +%Y%m%d.%H%m%S)

CURRDIR=$PWD
cd ~
#cd /tmp/testlinuxenvhome

F=.bash_logout
if [ -e $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

F=.bash_profile 
if [ -e $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

F=.bashrc
if [ -e $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

F=.gitconfig
if [ -e $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

F=.inputrc
if [ -e $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

F=.profile
if [ -e $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

F=bin
if [ -d $F ]; then
	mv $F ${F}.$d
fi
ln -s $CURRDIR/$F

