import pygame
import sys
meh = "/home/legostax/Music/Daft Punk - Harder, Better, Faster, Stronger.mp3"
pygame.init()
pygame.mixer.init()
pygame.mixer.music.load(meh)
pygame.mixer.music.play()
while pygame.mixer.music.get_busy():
    pygame.time.Clock().tick(10)

# Awesomewm writes to file to tell music.py what to do
# Commands: play, pause, next, back
# music.py returns with "success" overwriting the wm's command
# https://www.pygame.org/docs/ref/music.html
