#!/usr/bin/env python
#
# NRZ
# 2010dec09
# play random clips from a directory



# "Alex Martelli's solution as a module with proper process killing."
# http://stackoverflow.com/questions/1191374/subprocess-with-timeout
from os import kill
from signal import alarm, signal, SIGALRM, SIGKILL
from subprocess import PIPE, Popen

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
    

    # pause for minimization
    print 'starting in 20sec'
    time.sleep(20)

    # get a list of the video files to play
    media_dir = sys.argv[1]
    media_files = os.listdir(media_dir)

    # remove any directories from the list
    media_files = [ vfile for vfile in media_files if os.path.isfile(media_dir+vfile) ]

    # list of valid movie file types
    # note: invalid_exts = ['rmvb','srt','mp3','ac3','aac','wav']
    valid_exts = ['avi','mov','mpg','vob','mp4','mkv','mpeg','mp3','mv2','m4v','divx','xvid','bin']

    # check file types
    # throw out files that are not valid types
    media_files = [ vfile for vfile in media_files if (os.path.splitext(vfile)[1].strip('.') in valid_exts) ]

    # count number of valid movies
    numOfMovies = len(media_files)

    # initiate movie ring buffer the buffer size is 
    # about 1/3 of the total number of movies
    num_prev_movies = numOfMovies/3
    print 'num_prev_movies: '+str(num_prev_movies)
    prev_movies     = []

    # play movie clips forever!
    while(True):

        # pick a random movie that has not been picked for at
        # least 'num_prev_movies' movies ago
        prev_movie_flag = 1
        while prev_movie_flag:

            # pick a random movie from the list
            cur_movie_num  = random.randrange(0,numOfMovies)
            print "checking movie number: "+str(cur_movie_num)
            
            # check if its been one of he last movies alread picked
            try:
                prev_movies.index(cur_movie_num)
            # if it is not in the list then proceed out of the while loop
            except:
                print "movie not found in list, proceed"
                prev_movie_flag = 0

        # add current movie to ring buffer
        prev_movies.append(cur_movie_num)

        # prune ring buffer FIFO style
        if len(prev_movies) > num_prev_movies:
            prev_movies.pop(0)

        print "list len: "+str(len(prev_movies))
        print prev_movies

        # get cur movie path
        cur_movie_path = media_dir+media_files[cur_movie_num]

        print 'Movie Num: '+str(cur_movie_num)+'  |  '+cur_movie_path

        # get header info
        cmd = 'mplayer '+' -nosound -vo null -frames 0 -identify '+ cur_movie_path
        mp_retcod, mp_stdout, mp_stderr = run(cmd,shell=True,timeout=10)

        # if mplayer -identify was a success then process its stdout
        if mp_retcod != -9:
            # get movie length in sec
            id_st = mp_stdout.find('ID_LENGTH')
            id_ed = mp_stdout.find('\n',id_st)
            id_length = mp_stdout[id_st:id_ed].split('=')

            # if mplayer fails to get ID_LENGTH then just use 2hrs
            try:
                # get header value
                total_time = float(id_length[1])

                # check for invalid lengths like negative 
                # numbers or numbers larger than 4hrs
                if (total_time < 1) or (total_time > 60*60*4):
                    # default value
                    print 'Warning: invalid time stamp in header: '+str(total_time)
                    total_time = 60*60*2
            except:
                # get default value
                print 'Warning: no ID_LENGTH in header.'
                total_time = 60*60*2
        else:
            # get default value
            print 'Warning: mplayer -identify failed.'
            total_time = 60*60*2

        # find random seek point in movie
        max_time = int(float(total_time) * 0.9)
        start_time = random.randrange(0,max_time)
        print 'Length: '+str(total_time)+'sec  |  Seek: '+str(start_time)+'sec  |  ' \
            +str(int(float(start_time)*101.0/float(total_time)))+'%'

        # play a 30 second clip
        # -fs
        cmd = 'mplayer -fs '+' -quiet '+'-cache 8192 '+'-ss '+str(start_time)+' '+cur_movie_path

        # check if movie is done playing
        clip_length = random.randrange(0,3+1) # choose a random clip time option

        # process clip times
        if clip_length == 0:
            clip_length = 15
        elif clip_length == 1:
            clip_length = 30
        elif clip_length == 2:
            clip_length = 60
        elif clip_length == 3:
            clip_length = 2*60
        if mp_retcod == -9: # minimize the wait time if mplayer isn't working
            clip_length = 15
        print "clip length (sec): "+str(clip_length)

        # play clip and kill at timeout
        np_retcod, mp_stdout, mp_stderr = run(cmd,shell=True,timeout=clip_length)


