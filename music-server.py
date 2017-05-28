import socket
import sys
import pygame
import subprocess
import time
from threading import Thread
from random import shuffle
from os import listdir
from os import getpid
from os.path import isfile, join, expanduser

pygame.init()
pygame.mixer.init()

MAX_LENGTH = 4096
isPlaying = False
isPaused = False
isRunning = False
musicVolume = 0.25 # between 0 and 1
musicPath = expanduser("~").."/Music/wmplaylist/"
pidPath = expanduser("~").."/.config/awesome/.pymusic-serverpid.txt"
songPath = expanduser("~").."/.config/awesome/.pymusic-song.txt"
procpid = getpid()
currentsong = 0

# read pidPath and run kill pid
if isfile(pidPath):
    f = open(pidPath, 'r')
    subprocess.call(["kill", "-9", f.read()])
    f.close()

# write procpid to file
f = open(pidPath, 'w')
f.truncate()
f.write(str(procpid))
f.close()

# Write "Nothing is playing." to music file
f = open(songPath, 'w')
f.truncate()
f.write("Nothing is playing.")
f.close()

time.sleep(0.5)

songs = [f for f in listdir(musicPath) if isfile(join(musicPath, f))]
songslen = len(songs)
shuffle(songs)

def write_file_song(name):
    global songPath
    f = open(songPath, 'w')
    f.truncate()
    f.write(name[:-4])
    f.close()

def handle(clientsocket):
    global isPlaying
    global isPaused
    global songs
    global songslen
    global currentsong
    global isRunning
    while 1:
        buf = clientsocket.recv(MAX_LENGTH)
        if buf == '': return
        if buf == 'play':
            if isPlaying == False:
                isPlaying = True
                print 'playing...'
                if isPaused == False: # first cycle
                    pygame.mixer.music.load(musicPath + songs[currentsong])
                    pygame.mixer.music.set_volume(musicVolume)
                    pygame.mixer.music.play()
                    write_file_song(songs[currentsong])
                else:
                    pygame.mixer.music.unpause()
        elif buf == 'pause':
            if isPlaying == True:
                isPlaying = False
                isPaused = True
                print 'pausing...'
                pygame.mixer.music.pause()
        elif buf == 'next':
            print 'next song'
            isPlaying = True
            currentsong += 1
            if currentsong == songslen:
                currentsong = 0
            pygame.mixer.music.load(musicPath + songs[currentsong])
            pygame.mixer.music.set_volume(musicVolume)
            pygame.mixer.music.play()
            write_file_song(songs[currentsong])
        elif buf == 'back':
            print 'previous song'
            isPlaying = True
            currentsong -= 1
            if currentsong == -1:
                currentsong = songslen-1
            pygame.mixer.music.load(musicPath + songs[currentsong])
            pygame.mixer.music.set_volume(musicVolume)
            pygame.mixer.music.play()
            write_file_song(songs[currentsong])
        elif buf == 'kill':
            print 'killing...'
            pygame.mixer.music.stop()
            isRunning = False
            sys.exit(0)


def checkMusicPlayback():
    global songslen
    global songs
    global currentsong
    global isPlaying
    global isRunning
    while 1:
        if isRunning == False:
            sys.exit(0)
        while pygame.mixer.music.get_busy():
            pygame.time.Clock().tick(10)
        if isPlaying == True:
            currentsong += 1
            if currentsong == songslen:
                shuffle(songs)
                currentsong = 0
            pygame.mixer.music.load(musicPath + songs[currentsong])
            pygame.mixer.music.set_volume(musicVolume)
            pygame.mixer.music.play()
            write_file_song(songs[currentsong])
        pygame.time.Clock().tick(10)

mp = Thread(target=checkMusicPlayback)

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

PORT = 10000
HOST = '127.0.0.1'

print "opening socket..."
serversocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
serversocket.bind((HOST, PORT))
serversocket.listen(10)
isRunning = True
mp.start()

while 1:
    (clientsocket, address) = serversocket.accept()
    ct = Thread(target=handle, args=(clientsocket,))
    ct.run()
