#!/bin/bash

if [ $# -eq 0 ];
  then
    echo "err"
    exit 1
fi

rm -r *.txt
NUM_FILES=$1

for (( i = 0; i < NUM_FILES; i++ )); do
    FILE_NAMES="$i-$RANDOM.txt"
    RANDOM_TXT=$(head /dev/urandom | head -c 100)
    echo "$RANDOM_TXT" > "/home/MaksymM/practice/2025-02-11/$FILE_NAMES"
done
echo "OK!"
for FILE in *.txt
  do
  echo ""
  cat $FILE
done
