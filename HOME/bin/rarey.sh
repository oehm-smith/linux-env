#!/bin/bash

par2 r *PAR2 *par2 *rar; par2 c *PAR2 *par2 *rar
for i in *rar
do
	echo $i
	unrar e -or "$i"
done

