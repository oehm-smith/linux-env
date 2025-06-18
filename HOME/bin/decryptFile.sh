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
        echo USAGE: $0 PW *files Or dirs to decrypt*
        exit 1
fi
echo "Enter password"
read -s PASS; echo; RESULT=$(echo "$PASS" | md5sum | awk '{print $1}') && pw="$PASS$RESULT"
original_pw="$PASS"
#echo pw: "$pw"
if [ -z "$pw" ]; then
        echo USAGE: $0 PW *files Or dirs tar to decrypt* - missing password
        exit 1
fi

# Function to try decryption with a given password
try_decrypt() {
    local password="$1"
    local input_file="$2"
    local output_file="$3"
    
    openssl aes-256-cbc -d -a -pbkdf2 -pass "pass:$password" -in "$input_file" > "$output_file" 2>/dev/null
    return $?
}

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
  
  # Try MD5-modified password first
  echo openssl aes-256-cbc -d -a -pbkdf2  -pass "pass:***" -in "$encFile" \> "$tarName"
  if try_decrypt "$pw" "$encFile" "$tarName"; then
    echo "Decryption successful with modified password"
  else
    echo "Modified password failed, trying original password..."
    rm -f "$tarName"  # Clean up failed attempt
    if try_decrypt "$original_pw" "$encFile" "$tarName"; then
      echo "Decryption successful with original password"
    else
      echo "Error: Both password attempts failed - aborting"
      rm -f "$tarName"  # Clean up failed attempt
      exit 2
    fi
  fi
  
  if [ -e "$outName" ]; then
    echo Output results file already exists - aborting: $outName
    exit 1
  fi
  echo tar xzf "$tarName" \> "$outName"
  tar xzf "$tarName" > "$outName"
  echo rm "$tarName"
  rm "$tarName"
done
