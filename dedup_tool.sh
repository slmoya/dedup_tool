#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source_directory> <temp_directory> <num_cores>"
    exit 1
fi

source_directory="$1"
temp_directory="$2"
num_cores="$3"
total_duplicates=0
export source_directory temp_directory  # Export so that parallel can access them

deduplicate_file() {
    local file_path="$1"
    local relative_path="${file_path#$source_directory/}"
    local temp_file="$temp_directory/${relative_path//\//_}.tmp"
    local file_duplicates=0

    # Print progress
    echo "Processing: $file_path"

    # Count duplicates and write unique lines to temp file
    file_duplicates=$(awk '
    {
        if (!seen[$0]++) {
            print $0 > temp_file;
        } else {
            file_duplicates++;
        }
    }
    END { print file_duplicates }
    ' temp_file="$temp_file" file_duplicates="$file_duplicates" "$file_path")

    # Update total duplicates (atomic operation)
    echo "$file_duplicates" >> "$temp_directory/duplicate_counts.log"

    # Replace the original file with the deduplicated file
    mv "$temp_file" "$file_path"
}

export -f deduplicate_file  # Export function so that parallel can use it

deduplicate_directory() {
    # Create temp directory if it doesn't exist
    mkdir -p "$temp_directory"
    > "$temp_directory/duplicate_counts.log"  # Clear or create the log file

    # Find all files and process them in parallel using specified number of cores
    find "$source_directory" -type f | parallel -j "$num_cores" deduplicate_file

    # Sum up all duplicate counts
    total_duplicates=$(awk '{s+=$1} END {print s}' "$temp_directory/duplicate_counts.log")

    # Print the total number of duplicates removed
    echo "Total duplicates removed: $total_duplicates"
}

# Run the deduplication
deduplicate_directory "$source_directory" "$temp_directory"
