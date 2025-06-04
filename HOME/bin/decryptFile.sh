#!/usr/bin/env sh
# pw=$1
# shift

SAVEIFS=$IFS
IFS=$'\n'

encFiles=("$@")
echo encFiles: "${encFiles[@]}"

#encFiles="$@"
#echo encFiles: $encFiles

if [ -z "${encFiles[@]}" ]; then
	echo USAGE: $0 PW _files Or dirs to decrypt_
	exit 1
fi

echo "Enter password"
read -s PASS; echo; RESULT=$(echo "$PASS" | md5sum | awk '{print $1}') && pw="$PASS$RESULT"
#echo pw: "$pw"

if [ -z "$pw" ]; then
	echo USAGE: $0 PW _files Or dirs tar to decrypt_ - missing password
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

for encFile in "${encFiles[@]}"
do
  if [ ! -e "$encFile" ]; then
    echo USAGE: $0 file Or dir to encrypt - aint exist: $encFile
    exit 1
  fi

  # I was originally using pipes for this, but if the openssl fails it will still create output file
  tarName=$(basename "$encFile" .enc)
  outName=$(basename "$encFile" .tgz.enc)

  if [ -e "$tarName" ]; then
    echo Output tar file already exists - aborting: $tarName
    exit 1
  fi
  echo openssl aes-256-cbc -d -a -pbkdf2  -pass "pass:***" -in "$encFile" \> "$tarName"
  openssl aes-256-cbc -d -a -pbkdf2 -pass "pass:$pw" -in "$encFile" > "$tarName"

  if [ $? -ne 0 ]; then
    echo Error in openssl - aborting - $?
    rm "$tarName"
    exit 2
  fi

  if [ -e "$outName" ]; then
    echo Output results file already exists - aborting: $outName
    exit 1
  fi
  echo tar xzf "$tarName" \> "$outName"
  tar xzf "$tarName" > "$outName"

  echo rm "$tarName"
  rm "$tarName"

#  echo tar cz "$file" pipe openssl aes-256-cbc -a -salt -pbkdf2 -pass "pass:***" -out "$file.tgz.enc"
#  tar cz "$file" | openssl aes-256-cbc -a -salt -pbkdf2 -pass 'pass:$pw' -out "$file.tgz.enc"
done

# Use PW such as encrypt LLM

#name=$(basename "$encFile" .tgz.enc)
#
#echo openssl aes-256-cbc -d -a -pbkdf2 -in "$encFile" PIPE tar xz
#openssl aes-256-cbc -d -a -pbkdf2 -in "$encFile" | tar xz > "$name"
