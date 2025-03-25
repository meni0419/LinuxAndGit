#!/bin/bash
backup_dirs=("/opt" "/home/ec2-user" "/home/AndreevV")
backup_location="/tmp/backup"
mkdir -p "$backup_location"
#for dir in "${backup_dirs[@]}";
# do
#
backup_name="$backup_location/$(basename "$dir")_backup_$(date +%Y%m%d').tar.bz"
# echo "$backup_name"
# tar -cjvf "$backup_name" "$dir"
# done
Find "$backup_location" -type f -name "*tar.bz" -cmin +6 -exe rm -rf {} \