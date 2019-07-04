function word-of-the-day {
	local file="${1:-/usr/share/dict/words}";
	if ! [ -r "$file" ]; then
		echo "Cannot read from dictionary file: $file" 1>&2;
		return 1;
	fi;
	local IFS=$'\n' words=($(<"$file"));
	local num_words=${#words[@]};
	# The silly math is to half-assedly compensate for $RANDOM's range being
	# from 0 to 32767, while there are many more words in the dictionary.
	local word="${words[$((($num_words / 32767 * $RANDOM) % $num_words))]}"
	echo "$word";
}

