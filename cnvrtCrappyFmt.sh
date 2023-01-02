#!/bin/bash
# Author: Nick Zwart
# Date: 2010mar14

set -x 
set -e


# recurse into all lower dirs for mov files
FILES=`find . -name "*.mov"`

# allow for file names with spaces and other characters
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# for each file...
for i in $FILES
do

  # strip the directory from the file name
  NEWNAME=`basename $i`

  # use new directory for output
  NEWDIR='/Users/christy/Desktop/tcode/'

  # concatenate output dir and new name
  CATNAME="$NEWDIR/$NEWNAME.mp4"
  echo "$i to $CATNAME"

  # for movies with audio
  # /Applications/HandBrakeCLI -i "$i" --preset='iPhone & iPod Touch' -b 350 -2 -T -o "$CATNAME" & 

  # no audio
  /Applications/HandBrakeCLI -a 'none' -i "$i" --preset='iPhone & iPod Touch' -b 350 -2 -T -o "$CATNAME" & 

  wait

done

# reset character string environment
IFS=$SAVEIFS






