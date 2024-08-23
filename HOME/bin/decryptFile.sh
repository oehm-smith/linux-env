#!/usr/bin/env sh

pw=$1
shift

encFiles="$@"
echo encFiles: $encFiles

if [ -z "pw" ]; then
	echo USAGE: $0 PW _files Or dirs tar to decrypt_ - missing password
	exit 1
fi

if [ -z "$encFiles" ]; then
	echo USAGE: $0 PW _files Or dirs to decrypt_
	exit 1
fi

#if [ -z "$encFile" ]; then
#	echo USAGE: $0 file Or dir to decrypt
#	exit 1
#fi
#
#if [ ! -e "$encFile" ]; then
#	echo USAGE: $0 file Or dir to decrypt
#	exit 1
#fi

for encFile in $encFiles
do
  if [ ! -e "$encFile" ]; then
    echo USAGE: $0 file Or dir to encrypt - aint exist: $encFile
    exit 1
  fi

  name=$(basename "$encFile" .tgz.enc)

  echo openssl aes-256-cbc -d -a -pbkdf2  -pass "pass:***" -in "$encFile" PIPE tar xz
  openssl aes-256-cbc -d -a -pbkdf2 -pass 'pass:$pw' -in "$encFile" | tar xz > "$name"

#  echo tar cz "$file" pipe openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:***" -out "$file.tgz.enc"
#  tar cz "$file" | openssl aes-256-cbc -a -salt -pbkdf2 -pass 'pass:$pw' -out "$file.tgz.enc"
done

# Use PW such as encrypt LLM

#name=$(basename "$encFile" .tgz.enc)
#
#echo openssl aes-256-cbc -d -a -pbkdf2 -in "$encFile" PIPE tar xz
#openssl aes-256-cbc -d -a -pbkdf2 -in "$encFile" | tar xz > "$name"