#!/usr/bin/env bash

# Install these files into current users home
# Any existing files are renamed with a unique date extension

d=$(date +%Y%m%d.%H%m%S)

CURRDIR=$PWD
cd /etc
#cd /tmp/testlinuxenvhome

F=bash.bashrc
if [ -e $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=bash_completion.d
if [ -e $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=bashrc
if [ -e $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=bashrc.d
if [ -e $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=bashrc.d.direct
if [ -e $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=bashrc.debug
if [ -e $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=profile
if [ -d $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=profile.d
if [ -d $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F

F=profile.debug
if [ -d $F ]; then
	sudo mv $F ${F}.$d
fi
sudo ln -s $CURRDIR/$F
