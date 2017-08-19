import sys, socket, time, signal
from subprocess import Popen
from threading import Thread
from random import shuffle
from os import listdir, kill
from os.path import isfile, join, expanduser

MAX_LENGTH = 4096
ffproc = None
isPlaying = False
isPaused = False
isRunning = False
musicVolume = 0.5 # between 0 and 1
musicPath = expanduser("~/Music/wmplaylist/")
songPath = expanduser("~/.config/awesome/.pymusic-song.txt")
currentsong = 0
HOST = "127.0.0.1"
PORT = 10000
serversocket = None

# establish connection with existing instance
s = socket.socket()
try:
    s.connect((HOST, PORT))
    s.send("kill")
    s.close()
except:
    pass

f = open(songPath, "w")
f.truncate()
f.write("Nothing is playing.")
f.close()

songs = [f for f in listdir(musicPath) if isfile(join(musicPath, f))]
songslen = len(songs)
shuffle(songs)

def write_file_song(name):
    global songPath
    f = open(songPath, "w")
    f.truncate()
    f.write(name[:-4])
    f.close()

def handle(clientsocket):
    global ffproc
    global isPlaying
    global isPaused
    global songs
    global songslen
    global currentsong
    global isRunning
    global serversocket
    global musicVolume
    while 1:
        buf = clientsocket.recv(MAX_LENGTH)
        if buf == "": return
        if buf == "kill":
            if isPlaying == True:
                kill(ffproc.pid, signal.SIGTERM)
            serversocket.shutdown(socket.SHUT_RDWR)
            serversocket.close()
            isRunning = False
            sys.exit(0)
        elif buf == "play":
            if isPlaying == False:
                isPlaying = True
                print "playing..."
                if isPaused == False: # first cycle
                    # spawn new ffplay process
                    ffproc = Popen(["ffplay", "-nodisp", "-nostats", "-autoexit", "-af", str("volume=" + str(musicVolume)), str(musicPath + songs[currentsong])])
                    # write song name to file
                    write_file_song(songs[currentsong])
                else:
                    # SIGCONT ffplay proc
                    kill(ffproc.pid, signal.SIGCONT)
        elif buf == "pause":
            if isPlaying == True:
                isPlaying = False
                isPaused = True
                # SIGSTOP ffplay proc
                kill(ffproc.pid, signal.SIGSTOP)
                print "paused."
        elif buf == "next":
            print "next song"
            if isPlaying == True:
                # SIGTERM current ffplay proc
                kill(ffproc.pid, signal.SIGTERM)
            isPlaying = False
            currentsong += 1
            if currentsong == songslen:
                currentsong = 0
            # spawn new ffplay proc
            ffproc = Popen(["ffplay", "-nodisp", "-nostats", "-autoexit", "-af", str("volume=" + str(musicVolume)), str(musicPath + songs[currentsong])])
            # write song name to file
            write_file_song(songs[currentsong])
            isPlaying = True
        elif buf == "back":
            print "previous song"
            if isPlaying == True:
                # SIGTERM current ffplay proc
                kill(ffproc.pid, signal.SIGTERM)
            isPlaying = False
            currentsong -= 1
            if currentsong == -1:
                currentsong = songslen
            # spawn new ffplay proc
            ffproc = Popen(["ffplay", "-nodisp", "-nostats", "-autoexit", "-af", str("volume=" + str(musicVolume)), str(musicPath + songs[currentsong])])
            # write song name to file
            write_file_song(songs[currentsong])
            isPlaying = True


def checkMusicPlayback():
    global ffproc
    global songs
    global songslen
    global currentsong
    global musicVolume
    global isPlaying
    global isRunning
    while 1:
        if isRunning == False:
            sys.exit(0)
        if isPlaying == True:
            # check if current ffplay's popen.returncode ~= None
            if ffproc.poll() != None:
                currentsong += 1
                if currentsong == songslen:
                    shuffle(songs)
                    currentsong = 0
                # play new song
                ffproc = Popen(["ffplay", "-nodisp", "-nostats", "-autoexit", "-af", str("volume=" + str(musicVolume)), str(musicPath + songs[currentsong])])
                write_file_song(songs[currentsong])
        time.sleep(0.1)

mp = Thread(target=checkMusicPlayback)

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
time.sleep(0.5)
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
