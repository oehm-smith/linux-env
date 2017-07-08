#!/usr/bin/env bash
for i in $*
do
	echo $i
	display -resize ${X_WIDTH}x${X_HEIGHT} $i
done

