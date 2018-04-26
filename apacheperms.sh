#!/bin/bash
# apacheperms.sh - by mveenstra
# Automatically reconfigure Apache filesystem ownership and permissions.
#
# - Sets user and group ownership to the Apache user defined in config below,
# - Sets all directories to 775 and files to 664
# - Enable the setgid bit for directories so child files will inherit group ownership

## CONFIG SECTION ##########
apacheroot='/var/www/html'
apacheuser='www-data'
apachegroup='www-data'
############################

if [ "$EUID" -ne 0 ]
then
  echo "Please run this script with root privileges."
  exit
fi

echo "/-------------------------------\\"
echo "| apacheperms.sh - by mveenstra |"
echo "|-------------------------------|"
echo "| Make sure you've got backups! |"
echo "| I'm not responsible if this   |"
echo "| catches everything on fire.   |"
echo "\-------------------------------/"
echo ""
echo "Apache root:  $apacheroot"
echo "Apache user:  $apacheuser"
echo "Apache group: $apachegroup"
read -p "Are these settings correct? [y/N] " -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Settings confirmed. Proceeding..."
else
  echo "Please update the config section of this script with the correct settings. Exiting."
  exit 0
fi

## Fix ownership
echo "Fixing user and group ownership..."
chown -R $apacheuser:$apachegroup "$apacheroot"

## Fix permissions
# Directories
echo "Fixing directory permissions..."
find $apacheroot -type d -exec chmod 2775 {} \;
# Files
echo "Fixing file permissions..."
find $apacheroot -type f -exec chmod 0664 {} \;

echo "Done."
