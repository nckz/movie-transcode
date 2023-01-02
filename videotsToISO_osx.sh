#!/bin/bash
# on mac osx us hdiutil to make 
# a dvd iso out of a VIDEO_TS
# ready for burning.

VOLUME_NAME=$1
VIDEO_TS_PARENT=$3

# blank means all fs-types will be generated
FS_TYPE=" "

#hdiutil makehybrid $FS_TYPE -default-volume-name $VOLUME_NAME -o $ISO_NAME $VIDEO_TS_PARENT

# mkisofs - part of cdrtools package
mkisofs -f -dvd-video -udf -V "$VOLUME_NAME" -o "$VOLUME_NAME.iso" "$VIDEO_TS_PARENT"


