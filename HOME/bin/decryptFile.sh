#!/usr/bin/env bash
#
# decryptFile.sh - File and Directory Decryption Script  
#
# DESCRIPTION:
#   Decrypts .tgz.enc files created by encryptFile.sh using AES-256-CBC.
#   Automatically decompresses tar archives and extracts contents.
#   Supports both original and MD5-strengthened password attempts.
#
# USAGE:
#   decryptFile.sh [--outdir OUTPUT_DIR] file1.tgz.enc [file2.tgz.enc ...]
#
# ARGUMENTS:
#   --outdir DIR    Optional output directory for decrypted files
#   *.tgz.enc       Encrypted files to decrypt (one or more required)
#
# OUTPUT:
#   Extracts original files/directories from encrypted archives
#
# DECRYPTION:
#   - Algorithm: AES-256-CBC with base64 decoding
#   - Key derivation: PBKDF2
#   - Password attempts: 
#     1. User input + MD5(user input) (default from encryptFile.sh)
#     2. Original user input only (fallback)
#   - Decompression: Automatic gzip decompression after decryption
#
# PROCESS:
#   1. Prompts for password (hidden input)
#   2. Attempts decryption with strengthened password
#   3. Falls back to original password if needed
#   4. Extracts tar archive contents
#   5. Cleans up temporary files
#
# EXAMPLES:
#   decryptFile.sh documents.tgz.enc photos.tgz.enc
#   decryptFile.sh --outdir /restore backup.tgz.enc
#
# REQUIRES:
#   - openssl command
#   - tar command with gzip support  
#   - bash shell
#
# Author: [Your name]
# Version: 1.0
#

SAVEIFS=$IFS
IFS=$'\n'

# Parse command line arguments
outdir=""
encFiles=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --outdir)
            outdir="$2"
            shift 2
            ;;
        *)
            encFiles+=("$1")
            shift
            ;;
    esac
done

echo encFiles: "${encFiles[@]}"

if [ ${#encFiles[@]} -eq 0 ]; then
        echo "USAGE: $0 [--outdir OUTPUT_DIR] *files Or dirs to decrypt*"
        exit 1
fi

# Create output directory if specified and doesn't exist
if [ -n "$outdir" ]; then
    if [ ! -d "$outdir" ]; then
        echo "Creating output directory: $outdir"
        mkdir -p "$outdir"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create output directory: $outdir"
            exit 1
        fi
    fi
fi

echo "Enter password"
read -s PASS; echo; RESULT=$(echo "$PASS" | md5sum | awk '{print $1}') && pw="$PASS$RESULT"
original_pw="$PASS"

if [ -z "$pw" ]; then
        echo "USAGE: $0 [--outdir OUTPUT_DIR] *files Or dirs tar to decrypt* - missing password"
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
    echo "USAGE: $0 file Or dir to encrypt - aint exist: $encFile"
    exit 1
  fi
  
  # Determine output paths
  tarName=$(basename "$encFile" .enc)
  outName=$(basename "$encFile" .tgz.enc)
  
  # Apply output directory if specified
  if [ -n "$outdir" ]; then
    tarName="$outdir/$tarName"
    outName="$outdir/$outName"
  fi
  
  if [ -e "$tarName" ]; then
    echo "Output tar file already exists - aborting: $tarName"
    exit 1
  fi
  
  # Try MD5-modified password first
  echo "openssl aes-256-cbc -d -a -pbkdf2 -pass \"pass:***\" -in \"$encFile\" > \"$tarName\""
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
    echo "Output results file already exists - aborting: $outName"
    exit 1
  fi
  
  # Extract to output directory if specified
  if [ -n "$outdir" ]; then
    echo "tar xzf \"$tarName\" -C \"$outdir\""
    tar xzf "$tarName" -C "$outdir"
  else
    echo "tar xzf \"$tarName\" > \"$outName\""
    tar xzf "$tarName" > "$outName"
  fi
  
  echo "rm \"$tarName\""
  rm "$tarName"
done
