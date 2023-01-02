#!/usr/bin/env python
#
# NRZ
# 2011jan30
# transcode all vobs to mkv and pick all audio tracks and subtitle tracks


# "Alex Martelli's solution as a module with proper process killing."
# http://stackoverflow.com/questions/1191374/subprocess-with-timeout
from os import kill
from signal import alarm, signal, SIGALRM, SIGKILL
from subprocess import PIPE, Popen, call

def run(cmd, cwd = None, shell = False, kill_tree = True, timeout = -1):
    '''
    Run a command with a timeout after which it will be forcibly
    killed.
    '''
    class Alarm(Exception):
        pass

    def alarm_handler(signum, frame):
        raise Alarm

    p = Popen(cmd, shell = shell, cwd = cwd, stdout = PIPE, stderr = PIPE)

    if timeout != -1:
        signal(SIGALRM, alarm_handler)
        alarm(timeout)

    try:
        stdout, stderr = p.communicate()
        if timeout != -1:
            alarm(0)
    except Alarm:
        pids = [p.pid]
        if kill_tree:
            pids.extend(get_process_children(p.pid))
        for pid in pids:
            kill(pid, SIGKILL)
        return -9, '', ''

    return p.returncode, stdout, stderr

def get_process_children(pid):
    p = Popen('ps --no-headers -o pid --ppid %d' % pid, shell = True,
              stdout = PIPE, stderr = PIPE)
    stdout, stderr = p.communicate()
    return [int(p) for p in stdout.split()]

# Example usage:
#if __name__ == '__main__':
#    print run('find /', shell = True, timeout = 3)
#    print run('find', shell = True)


import os
import sys
import subprocess as sp
import time
import random


if __name__ == '__main__':
    
    iname = sys.argv[1]
    oname = iname.split('vob')[0] + 'mkv'

    if os.path.isfile(iname) == False:
        print 'Error: invalid input filename: '+iname
        sys.exit(1)

    cmd = 'HandBrakeCLI -t 1 --scan -i '+sys.argv[1]
    print cmd
    retcode, stdout, stderr = run(cmd,shell=True)

    print stderr
    st_audio = stderr.find('audio tracks')
    st_subs  = stderr.find('subtitle tracks',st_audio)
    end = stderr.find('HandBrake has exited.')

    # find fps, crop out the '+ size:' line
    st_size = stderr.find('+ size:')
    en_size = stderr.find('\n',st_size)
    size_str = stderr[st_size:en_size]
    fps_str = size_str.split(', ')[-1]
    fps = fps_str.split(' ')[0]

    # count number of audio tracks
    num_audio = 0
    no_carriage_returns = 0
    cur_pos = st_audio
    while no_carriage_returns == 0:
        cur_pos = stderr.find('\n',cur_pos+1,st_subs)
        if cur_pos != -1:
            num_audio += 1
        else:
            no_carriage_returns = 1
    num_audio -= 1 # don't count the first cr

    # count number of sub tracks
    num_subs = 0
    no_carriage_returns = 0
    cur_pos = st_subs
    while no_carriage_returns == 0:
        cur_pos = stderr.find('\n',cur_pos+1,end)
        if cur_pos != -1:
            num_subs += 1
        else:
            no_carriage_returns = 1
    num_subs -= 1 # don't count the first cr

    print "\nThis script found:"
    print 'num audio tracks = '+str(num_audio)
    print 'num sub tracks = '+str(num_subs)

    # make track selection string seq
    s_a = [ str(i) for i in range(1,num_audio+1) ]
    audio_string = ' -a '+','.join(s_a) + ' '
    s_a = [ 'copy' for i in range(1,num_audio+1) ]
    audio_codec = ' -E '+','.join(s_a) + ' '
    #s_a = [ 'Auto' for i in range(1,num_audio+1) ]
    #audio_srate = ' -R '+','.join(s_a) + ' '

    if num_subs > 0:
        s_s = [ str(i) for i in range(1,num_subs+1) ]
        subs_string = ' -s '+','.join(s_s) + ' '
    else:
        subs_string = ' '
    
    print "starting transcode"
    adv_ref = " -e x264 -x ref=2:bframes=2:subme=6:mixed-refs=0:weightb=0:8x8dct=0:trellis=0 "
    HighProfile = " -e x264 -q 20.0 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 " + audio_codec + audio_string + subs_string
    frameRate = ' --cfr -r '+fps+' '
    cmd = 'nice -n 19 HandBrakeCLI -f mkv -i '+iname+HighProfile+frameRate+' -o '+oname
    print cmd
    call(cmd,shell=True)


