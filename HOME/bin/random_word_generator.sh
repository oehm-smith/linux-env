#!/usr/bin/env bash
# Script to return a random number from /usr/share/dict/words
DEBUG=0

ALL_NON_RANDOM_WORDS=/usr/share/dict/words

number_words=$(cat $ALL_NON_RANDOM_WORDS | wc -l); 
random_number=`od -N3 -An -i /dev/urandom` 
let "word_choice=$random_number%$number_words"

if [ "$DEBUG" != "0" ]; then
	echo Number Words: $number_words 
	echo Grass Random Number: $random_number 
	echo Word Choice: $word_choice; 
fi

sed `echo $word_choice`"q;d" $ALL_NON_RANDOM_WORDS

