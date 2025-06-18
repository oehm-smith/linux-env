#!/usr/bin/env bash
#
# encryptFile.sh - File and Directory Encryption Script
#
# DESCRIPTION:
#   Encrypts files and directories using AES-256-CBC with PBKDF2 key derivation.
#   Creates compressed tar archives before encryption for efficient storage.
#   Supports password strengthening via MD5 hash concatenation.
#
# USAGE:
#   encryptFile.sh [--outdir OUTPUT_DIR] file1 [file2 dir1 ...]
#
# ARGUMENTS:
#   --outdir DIR    Optional output directory for encrypted files
#   file/dir        Files or directories to encrypt (one or more required)
#
# OUTPUT:
#   Creates .tgz.enc files containing encrypted, compressed archives
#
# ENCRYPTION:
#   - Algorithm: AES-256-CBC with base64 encoding
#   - Key derivation: PBKDF2 
#   - Password: User input + MD5(user input) for additional entropy
#   - Compression: gzip compression before encryption
#
# EXAMPLES:
#   encryptFile.sh documents/ photos.jpg
#   encryptFile.sh --outdir /backup files/ data.txt
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

if [ ${#fileOrDirs[@]} -eq 0 ]; then
        echo "USAGE: $0 [--outdir OUTPUT_DIR] *files Or dirs to encrypt*"
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

if [ -z "$pw" ]; then
        echo "USAGE: $0 [--outdir OUTPUT_DIR] *files Or dirs tar to encrypt* - missing password"
        exit 1
fi

for fileOrDir in "${fileOrDirs[@]}"
do
  if [ ! -e "${fileOrDir}" ]; then
    echo "USAGE: $0 file Or dir to encrypt - aint exist: ${fileOrDir}"
    exit 1
  fi
  
  # Determine output file path - handle directories properly
  baseName=$(basename "${fileOrDir}")
  encName="${baseName}.tgz.enc"
  
  # Apply output directory if specified
  if [ -n "$outdir" ]; then
    encName="$outdir/${baseName}.tgz.enc"
  fi
  
  if [ -e "$encName" ]; then
    echo "Output file already exists - aborting: $encName"
    exit 1
  fi
  
  echo "tar czf - \"${fileOrDir}\" | openssl aes-256-cbc -a -pbkdf2 -pass \"pass:***\" > \"$encName\""
  tar czf - "${fileOrDir}" | openssl aes-256-cbc -a -pbkdf2 -pass "pass:$pw" > "$encName"
done
