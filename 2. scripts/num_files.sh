#!/bin/bash

# Save the current path in a variable
current_path="$PWD"

# Count the number of directories
directories=$(find . -type d | wc -l)

# Count the number of files
files=$(find . -type f | wc -l)

# Output the results
echo "There are $directories directories and $files files in the path $current_path."
