#!/bin/bash

# Exit script on error
set -e
set -x

# Check if the script is run as root (required for modifying user accounts)
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root! Use sudo."
  exit 1
fi

# Input: old username and new username
OLD_USERNAME=$1
NEW_USERNAME=$2

# Check if input arguments are provided
if [[ -z "$OLD_USERNAME" || -z "$NEW_USERNAME" ]]; then
  echo "Usage: sudo ./rename_user.sh <old_username> <new_username>"
  exit 1
fi

# Check if the old user exists
if ! id "$OLD_USERNAME" &>/dev/null; then
  echo "User $OLD_USERNAME does not exist!"
  exit 1
fi

# Check if the new user already exists
if id "$NEW_USERNAME" &>/dev/null; then
  echo "User $NEW_USERNAME already exists!"
  exit 1
fi

echo "Renaming user from $OLD_USERNAME to $NEW_USERNAME..."

# Rename the user
echo "Renaming the user account..."
usermod -l "$NEW_USERNAME" "$OLD_USERNAME"

# Rename the home directory and move files
OLD_HOME="/home/$OLD_USERNAME"
NEW_HOME="/home/$NEW_USERNAME"
echo "Renaming home directory from $OLD_HOME to $NEW_HOME..."
usermod -d "$NEW_HOME" -m "$NEW_USERNAME"

# Update ownership of all files on the filesystem
echo "Updating file ownership from $OLD_USERNAME to $NEW_USERNAME..."
find / -user "$OLD_USERNAME" -exec chown -h "$NEW_USERNAME":"$NEW_USERNAME" {} \; 2>/dev/null

# Update sudoers file if needed
if grep -q "$OLD_USERNAME" /etc/sudoers; then
  echo "Updating sudoers file..."
  sed -i "s/$OLD_USERNAME/$NEW_USERNAME/g" /etc/sudoers
fi

# Update any existing crontabs
echo "Updating crontab..."
if crontab -l -u "$OLD_USERNAME" &>/dev/null; then
  crontab -l -u "$OLD_USERNAME" > /tmp/old_cron
  crontab -u "$NEW_USERNAME" /tmp/old_cron
  rm -f /tmp/old_cron
fi

# Update .ssh permissions (if SSH keys are present)
if [[ -d "$NEW_HOME/.ssh" ]]; then
  echo "Updating .ssh directory permissions..."
  chown -R "$NEW_USERNAME:$NEW_USERNAME" "$NEW_HOME/.ssh"
  chmod 700 "$NEW_HOME/.ssh"
  chmod 600 "$NEW_HOME/.ssh/authorized_keys"
fi

# Cleanup unused home directory (optional)
if [[ -d "$OLD_HOME" ]]; then
  echo "Cleaning up old home directory $OLD_HOME..."
  rm -rf "$OLD_HOME"
fi

echo "User rename completed successfully:
- Old username: $OLD_USERNAME
- New username: $NEW_USERNAME
- New home directory: $NEW_HOME"