#!/usr/bin/env sh
# Now read password on command line
# pw=$1
# shift

SAVEIFS=$IFS
IFS=$'\n'

# Parse command line arguments
outdir=""
fileOrDirs=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --outdir)
            outdir="$2"
            shift 2
            ;;
        *)
            fileOrDirs+=("$1")
            shift
            ;;
    esac
done

echo fileOrDirs: "${fileOrDirs[@]}"
if [ -n "$outdir" ]; then
    echo outdir: "$outdir"
fi

if [ -z "${fileOrDirs[@]}" ]; then
	echo USAGE: $0 [--outdir DIR] _files Or dirs to encrypt_
	exit 2
fi

# Check if outdir exists and is writable if specified
if [ -n "$outdir" ]; then
    if [ ! -d "$outdir" ]; then
        echo "Error: Output directory does not exist: $outdir"
        exit 5
    fi
    if [ ! -w "$outdir" ]; then
        echo "Error: Output directory is not writable: $outdir"
        exit 6
    fi
fi

echo "Enter password"
read -s PASS; echo; RESULT=$(echo "$PASS" | md5sum | awk '{print $1}') && pw="$PASS$RESULT"
#echo pw: "$pw"
if [ -z "$pw" ]; then
	echo USAGE: $0 [--outdir DIR] _files Or dirs to encrypt_ - missing password
	exit 1
fi

for file in "${fileOrDirs[@]}"
do
  echo file: "$file"
  if [ ! -e "$file" ]; then
    echo USAGE: $0 file Or dir to encrypt - not file: "$file"
    exit 3
  fi

  # Determine output file path
  if [ -n "$outdir" ]; then
    basename_file=$(basename "$file")
    output_file="$outdir/$basename_file.tgz.enc"
  else
    output_file="$file.tgz.enc"
  fi

  if [ -e "$output_file" ]; then
    echo Output file already exists - aborting: "$output_file"
    exit 4
  fi
  
  echo tar cz "$file" pipe openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:***" -out "$output_file"
  tar cz "$file" | openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:$pw" -out "$output_file"
done

# Use PW such as encrypt LLM
IFS=$SAVEIFS
