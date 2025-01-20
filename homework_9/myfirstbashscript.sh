#!/bin/bash
# ANSI escape codes for text colors
GREEN="\033[32m"
BLUE="\033[34m"
RESET="\033[0m"  # Resets the text color to default
USER=MaksumM
# Use tee to display colorized output and log plain text simultaneously
date
printf "Hello ${GREEN}%s${RESET}!\n" "$USER"
printf "Script run from ${BLUE}%s${RESET}!\n" "$(pwd)"
ps aux | grep bioset | grep -v grep | wc -l
ls -lah /etc/ | awk '$9 == "passwd" {print $1}'