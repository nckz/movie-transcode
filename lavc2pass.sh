#!/bin/bash
# use this shell script of lavc mpeg4 encoding
echo "start time: `date`" >> timexvid.txt

mencoder dvd://1 -dvd-device $1 -ovc lavc -lavcopts vcodec=mpeg4:vpass=1 -oac mp3lame -vf scale=640:360 -force-avi-aspect 640:360 -ofps 23.976 -o /dev/null

echo "end first pass time: `date`" >> timexvid.txt

mencoder dvd://1 -dvd-device $1 -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vpass=2 -oac mp3lame -vf scale=640:360 -force-avi-aspect 640:360 -ofps 23.976 -o $2 

echo "end second pass time: `date`" >> timexvid.txt
