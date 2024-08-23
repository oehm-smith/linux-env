#!/usr/bin/env sh
pw=$1
shift

fileOrDirs="$@"
echo fileOrDirs: $fileOrDirs

if [ -z "pw" ]; then
	echo USAGE: $0 PW _files Or dirs to encrypt_ - missing password
	exit 1
fi

if [ -z "$fileOrDirs" ]; then
	echo USAGE: $0 PW _files Or dirs to encrypt_
	exit 1
fi

for file in $fileOrDirs
do
  if [ ! -e "$file" ]; then
    echo USAGE: $0 file Or dir to encrypt
    exit 1
  fi

  echo tar cz "$file" pipe openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:***" -out "$file.tgz.enc"
  tar cz "$file" | openssl aes-256-cbc -a -salt -pbkdf2 -pass 'pass:$pw' -out "$file.tgz.enc"
done

# Use PW such as encrypt LLM