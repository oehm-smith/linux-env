#!/usr/bin/env sh
# Now read password on command line
# pw=$1
# shift

SAVEIFS=$IFS
IFS=$'\n'

fileOrDirs=("$@")
echo fileOrDirs: "${fileOrDirs[@]}"

if [ -z "${fileOrDirs[@]}" ]; then
	echo USAGE: $0 PW _files Or dirs to encrypt_
	exit 2
fi

echo "Enter password"
read -s PASS; echo; RESULT=$(echo "$PASS" | md5sum | awk '{print $1}') && pw="$PASS$RESULT"
#echo pw: "$pw"
if [ -z "$pw" ]; then
	echo USAGE: $0 PW _files Or dirs to encrypt_ - missing password
	exit 1
fi

for file in "${fileOrDirs[@]}"
do
  echo file: "$file"
  if [ ! -e "$file" ]; then
    echo USAGE: $0 file Or dir to encrypt - not file: "$file"
    exit 3
  fi

  if [ -e "$file.tgz.enc" ]; then
    echo Output file already exists - aborting: "$file.tgz.enc"
    exit 4
  fi
  echo tar cz "$file" pipe openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:***" -out "$file.tgz.enc"
  tar cz "$file" | openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:$pw" -out "$file.tgz.enc"
done

# Use PW such as encrypt LLM
IFS=$SAVEIFS
