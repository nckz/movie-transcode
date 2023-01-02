#!/bin/sh
echo "***********************************************************"
echo "Automated script created by AcidRip - http://acidrip.sf.net"
echo "***********************************************************"
mplayer dvd://1 -dvd-device /media/cdrom/VIDEO_TS  -dumpstream -dumpfile "/tmp//unknown-cache"
eject /media/cdrom/VIDEO_TS
unlink frameno.avi 2> /dev/null
mencoder /tmp//unknown-cache -oac mp3lame -lameopts abr:br=128 -aid 128 -ovc xvid -xvidencopts bitrate=1806:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=2:pass=1 -vf pp=de,crop=720:448:0:14,scale=0:0   -aid 128  -o "/dev/null"
mencoder /tmp//unknown-cache -oac mp3lame -lameopts abr:br=128 -aid 128 -ovc xvid -xvidencopts bitrate=1806:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=2:pass=2 -vf pp=de,crop=720:448:0:14,scale=0:0   -aid 128  -o "/mnt/sda3/home/nick/tcodeMovies/unknown.avi"
unlink divx2pass.log  2> /dev/null
unlink "/tmp//unknown-cache"
