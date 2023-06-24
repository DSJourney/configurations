#!/bin/bash

# Check if category is provided
if [ -z "$1" ]; then
  echo "Please provide a category"
  exit 1
fi

# Check if file exists
if [ ! -f /Users/diego/.pyenv/scripts/commands.txt ]; then
  echo "File commands.txt not found!"
  exit 1
fi

# Convert category to lower case and prepend #
category="# $(echo "$1" | tr '[:upper:]' '[:lower:]')"

# Define color and style codes
bold=$(tput bold)
blue=$(tput setaf 4)
reset=$(tput sgr0)

# Print commands from category
awk -v category="$category" -v bold="$bold" -v blue="$blue" -v reset="$reset" '
BEGIN {RS="\n"; FS="\n"; print "Category: " category}
$0 ~ category {flag=1; print "Matched category"; next}
flag && NF && !($0 ~ /^#/) {
  # Split the line into command and comment
  split($0, arr, "#")
  # Print the command in bold blue and the comment in default color
  print bold blue arr[1] reset (arr[2] ? " #" arr[2] : "")
  next
}
flag && ($0 ~ /^#/) {exit}' /Users/diego/.pyenv/scripts/commands.txt

## CODE EXPLAINED
# awk -v category="$category" -v bold="$bold" -v blue="$blue" -v reset="$reset":
# The awk command is widely used command for text processing. When using awk , you are able to select data – one or more pieces of individual text – based on a pattern you provide.
# This line initiates the awk command and assigns external variables (from the shell script) to internal awk variables so they can be used within the awk command.

# BEGIN {RS="\n"; FS="\n"; print "Category: " category}:
# This is a BEGIN block that runs before awk processes any input lines. RS is the input record separator, and FS is the input field separator, both set to "\n", meaning awk will treat each line as a record. Then it prints "Category: " followed by the category.

# $0 ~ category {flag=1; print "Matched category"; next}:
# This line checks if the current line ($0) matches the category. If it does, it sets a flag variable to 1 (indicating we've found the category we're interested in) and prints "Matched category". The next command tells awk to skip the rest of the script and move on to the next record.

# flag && NF && !($0 ~ /^#/)
# is a condition that checks if the flag is set (meaning we've found the category), the current line ($0) is not empty (NF), and the current line doesn't start with '#'.

# split($0, arr, "#"):
# If the condition is met, this line splits the current line ($0) into parts based on the "#" delimiter and stores them in the arr array.

# print bold blue arr[1] reset (arr[2] ? " #" arr[2] : ""):
# This line prints the command (the first part before "#", stored in arr[1]) in bold blue, and then resets the color. If there's a comment (the second part after "#", stored in arr[2]), it prints " #" followed by the comment.

# flag && ($0 ~ /^#/) {exit}:
#This condition checks if the flag is set and the current line starts with '#'. If true, it means we've reached another category, so it exits the awk command.
