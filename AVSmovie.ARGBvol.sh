#!/bin/bash
# this script can be used to make movies from argb volumes generated in AVS


WIDTH="768"
HEIGHT="768"
FPS="60"

# for x264 the bitrate is in Kb/s
# 900 is a good choice
BITRATE="900"

# argb doesn't work on any of the machines I have access to so the vectors either need to be changed to
# rgb24 or rgba(untested)
FORMAT="rgb24"

#RESOL="640:-3"
#SCALE="-vf scale=$RESOL"


# 2 pass xvid encoding
#mencoder $1 -demuxer rawvideo -rawvideo format=$FORMAT:h=$HEIGHT:w=$WIDTH:fps=$FPS -ovc xvid -xvidencopts pass=1:bitrate=$BITRATE:turbo=2:threads=2 $SCALE  -o /dev/null

#mencoder $1 -demuxer rawvideo -rawvideo format=$FORMAT:h=$HEIGHT:w=$WIDTH:fps=$FPS -ovc xvid -xvidencopts pass=2:bitrate=$BITRATE:threads=2 $SCALE  -o $2

# 1 pass x264 encoding
mencoder $1 -demuxer rawvideo -rawvideo format=$FORMAT:h=$HEIGHT:w=$WIDTH:fps=$FPS -ovc x264 -x264encopts pass=1:turbo=2:bitrate=$BITRATE $SCALE  -o "$2.avi"

# dump to h264
mplayer "$2.avi" -dumpvideo -dumpfile "$2.h264"

# convert to mp4 package
mp4creator -create="$2.h264" -rate=$FPS "$2.mp4"

