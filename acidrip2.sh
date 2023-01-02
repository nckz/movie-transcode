#!/bin/sh

# convert crappy formats to xvid

#echo "pass 1"
#mencoder $1 -oac mp3lame -lameopts abr:br=128 -aid 128 -ovc xvid -xvidencopts bitrate=1806:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=2:pass=1  -aid 128 -vf pp=de -o "/dev/null"

echo "pass 2"
mencoder $1 -oac mp3lame -lameopts abr:br=128 -aid 128 -ovc xvid -xvidencopts bitrate=1806:chroma_opt:vhq=4:bvhq=1:quant_type=mpeg:threads=2:pass=2  -aid 128 -vf pp=de -o $2


