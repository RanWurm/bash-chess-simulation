#!/bin/bash

# checks if exactly 2 parameter has passed
if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_pgn_file> <destination_directory>"
    exit 1
fi

# checks if exactly 2 parameter has passed
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist."
    exit 1
fi

if [ ! -d "$2" ]; then
    mkdir -p "$2"
    echo "Created directory '$2'."
fi

source_pgn_file="$1"
destination_directory="$2"
counter=1
curr_game=""
name=$(basename "$file" .pgn)

while IFS= read -r line
do
    if [[ "$line" =~ \[Event\ \".*\"\] ]]; then
        if [ ! -z "$curr_game" ]; then
            echo "$curr_game" > "$destination_directory/${name}_$counter.pgn"
            ((counter++))
            curr_game=""
        fi
    fi
    curr_game+="$line"$'\n'
done < "$source_pgn_file"

if [ ! -z "$curr_game" ]; then
    echo "$curr_game" > "$destination_directory/${name}_$counter.pgn"
fi



