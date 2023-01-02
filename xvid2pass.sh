#!/bin/bash
# this shell script encodes VIDEO_TS directorys into divx using the xvid encoder
#
# use a negative bitrate to specify the target movie file size (eg. -700000 for 700MB CD size file)
# a bitrate of 650 is pretty good for most things and I think its the default
#
# aspect and resolution
# 640:480 for 4:3 or 1.333333
# 640:360 for 16:9 or 1.777777
#
#-endpos 01:10:00
# Stop at 1 hour 10 minutes.
#
#-ss 01:10:00
# Seeks to 1 hour 10 min.

# dropped -force-avi-aspect $RESOL
# added the "-3" to RESOL which makes mencoder calculate this dim based on given dim and original aspect.

# Take scaling out and see how this performs
#RESOL="640:-3"
#SCALE="-vf scale=$RESOL"

FPS="-ofps 23.976"

# we don't need to fit on single CDs, lets double the allowed amount
# from -700,000KB target to -1,500,000KB target.  The usual DVD bitrate
# is 9.8Mb/s which results in roughly -4,700,000KB.
BITRATE="-1500000"

# languages     en=English
#               ja=Japanese
#               hu=Hungarian
#               fr=French
# look at -identify to find the track types on any dvd
AUDIO_LANG="-alang en"
# this will render subs into the movie so no extra file, however, no way of separating later
#SUB_LANG="-slang en"

# for most, the main feature is track 1 
TRACK=3

# if the dvd device can't be used directly, point to the VIDEO_TS dir.
ALTERNATE_DEVICE="-dvd-device $1"
#DUMMY_DEVICE="$1"

#START_POS="-ss 00:02:30"
#END_POS="-endpos 00:03:30"


echo "start time: `date`" >> timexvid.txt

mencoder dvd://$TRACK $ALTERNATE_DEVICE -ovc xvid -oac mp3lame -xvidencopts pass=1:bitrate=$BITRATE:turbo=2:threads=2 $SCALE $AUDIO_LANG $SUB_LANG $START_POS $END_POS $FPS -o /dev/null

echo "end first pass time: `date`" >> timexvid.txt

mencoder dvd://$TRACK $ALTERNATE_DEVICE -ovc xvid -oac mp3lame -xvidencopts pass=2:bitrate=$BITRATE:threads=2 $SCALE $AUDIO_LANG $SUB_LANG $START_POS $END_POS $FPS -o $2 

echo "end second pass time: `date`" >> timexvid.txt

