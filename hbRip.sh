# some lines used to rip using HandBrakeCLI
1916  HandBrakeCLI -t 0 -U -i /media/cdrom/VIDEO_TS/
1917  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o UpInTheAir.mp4 -a "1,2,3,4"
1918  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o UpInTheAir.mp4 -a "1,2,3,4" -L
1938  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o PrincessBride.mp4
1944  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o PrincessBride_aa_as.mp4 -a "1,2,3,4" -s "1,2,3"
1961  HandBrakeCLI -i /media/cdrom/VIDEO_TS -t 0 -U
1963  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o ILoveYouMan.mp4 -a "1,2,3" -U -F
1964  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o ILoveYouMan.mp4 -a "1,2,3,4" -U -F
1977  HandBrakeCLI -i /media/cdrom/VIDEO_TS -t 0 -U
1978  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o TheBlindSide.mp4 -a "1,2,3,4" -U -F
1979  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o TheBlindSide.mp4 -a "1,2" -U -F
2044  HandBrakeCLI -i /media/cdrom/VIDEO_TS -t 0 -U
2046  HandBrakeCLI -i /media/cdrom/VIDEO_TS -o AmericanGangster.mp4 -a "1,2,3" -U -F

# to check
HandBrakeCLI -t 0 -U -i /media/cdrom/VIDEO_TS/

# to encode with normal setting
HandBrakeCLI -i /media/cdrom/VIDEO_TS -o AmericanGangster.mp4 -a "1,2,3" -U -F

# to encode with high profile 'Film' setting
HandBrakeCLI -i /media/cdrom/VIDEO_TS -o AmericanGangster.mp4 -a "1,2,3" -U -F -Z "Film"
