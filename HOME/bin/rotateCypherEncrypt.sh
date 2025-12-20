#!/bin/bash

# A simple rotation cipher (also known as a Caesar cipher)
# Encrypts a string by shifting each letter by a specified number of positions.

# Function to display usage information
usage() {
    echo "Usage: $0 <string_to_encrypt> <rotation_key>"
    echo "Example: $0 'Hello World' 3"
    exit 1
}

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    usage
fi

input_string=$1
key=$2

# Validate the key to ensure it's a number
if ! [[ "$key" =~ ^[0-9]+$ ]]; then
    echo "Error: Rotation key must be a positive integer."
    usage
fi

# The main logic for encryption
encrypted_string=""
for (( i=0; i<${#input_string}; i++ )); do
    char=${input_string:i:1}
    
    # Check if the character is a letter
    if [[ "$char" =~ [a-zA-Z] ]]; then
        # Get the ASCII value of the character
        ascii_val=$(printf "%d" "'$char")
        
        # Determine the base ASCII value for uppercase or lowercase letters
        if [[ "$char" =~ [A-Z] ]]; then
            base_ascii=65 # ASCII for 'A'
            
        else
            base_ascii=97 # ASCII for 'a'
        fi
        
        # Perform the rotation calculation
        # The modulo operation wraps the rotation around the alphabet
        shifted_val=$(( (ascii_val - base_ascii + key) % 26 ))
        
        # Convert the new ASCII value back to a character
        new_char=$(printf "\\$(printf '%o' $((base_ascii + shifted_val)))")
        encrypted_string+=$new_char
    else
        # If the character is not a letter, add it to the string as is (e.g., spaces, punctuation)
        encrypted_string+=$char
    fi
done

echo "Original string:  $input_string"
echo "Rotation key:     $key"
echo "Encrypted string: $encrypted_string"

