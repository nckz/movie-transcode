#!/bin/sh

TITLE=$1
OUTPUT_FILE=$2

echo "caching DVD stream to $OUTPUT_FILE"
#mplayer dvd://1 -dvd-device /media/cdrom/VIDEO_TS  -dumpstream -dumpfile "$1"
mplayer dvd://$TITLE  -dumpstream -dumpfile "$OUTPUT_FILE"
chown nick:nick $OUTPUT_FILE
#eject 

