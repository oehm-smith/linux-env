#!/bin/bash
# Creating tests for bin/loadbindir.pl (http://eeow.local/svn/bsmith/bin/loadbindir.pl)
# Purpose
#		Creates dirs_to_create dirs called 'appX' where x in (1..dirs_to_create)
#		And in each of these exes_to_create executable dummy files called 'exeX.Y'
#			where y in (1 .. exes_to_create).
#		IT also creates a file $dest/apps.list to be used by bin/loadbindir.pl
#		Args:
#			$1 - dest directory to create these in.  THE CONTENTS WILL BE DELETED FIRST.
#			$2 - dirs_to_create = number of 'appX' dirs to create
#			$3 - exes_to_create = number of dummy executables in each 'appX' to create
#					called appX/exeX.Y

if [ $# -lt 3 ]; then
	echo Usage: $0 dir_to_create_test_dirs_in num_dirs num_exes
	echo  Creates num_dir dirs called 'appX' where x is 1 .. num_dirs
	echo		and num_exes dummy exes called 'appX/exeX.Y' where y is 1 .. num_exes
	echo	Then used by bin/loadbindir.sh to test its functionality.
	echo	use 'time ...' to test the time it will take different runs to take.
	exit 1
fi

dest=$1
dirs_to_create=$2
exes_to_create=$3

echo dest: $dest
echo dirs_to_create: $dirs_to_create
echo exes_to_create: $exes_to_create

# Set output_dest to the destination directory and make absolute if relative
dest_first_char=$(echo $dest | cut -c1)
dest_rest=$(echo $dest | cut -c2-)
if [ $dest_first_char == "." ]; then
	output_dest=${PWD}$dest_rest
else
	output_dest=$dest
fi
echo output_dest: $output_dest

not_empty=0
for i in `/bin/ls $dest`; do
	echo $i
	not_empty=1
done

if [ $not_empty -gt 0 ]; then
	echo dest: $dest isnt empty, deleting contents
	rm -r $dest/*
fi

i=1
while [ $i -le $dirs_to_create ]; do
	#echo $i
	mkdir app$i
  echo $output_dest/app$i
	echo $output_dest/app$i >> $dest/apps.list
	j=1
	while [ $j -le $exes_to_create ]; do
	  #echo $i.$j
	  touch app$i/exe$i.$j
	  chmod +x app$i/exe$i.$j
	  let j=j+1
	done
	let i=i+1 
done