#!/usr/bin/python3
import shutil
from pathlib import Path
import random
import os

source = "/home/toni/music/"
target = "/home/toni/musicForPhone/"

albums = [Path(source, x) for x in os.listdir(source) if Path(source, x).is_dir()]

numArtists = 100
randomArtists = random.sample(albums, numArtists)
for artist in randomArtists:
    # ugly as shit but my back hurts and i wanna get this done
    source = artist
    target = str(artist).replace("music/", "musicForPhone/")
    print(source, target)
    shutil.copytree(source, target)
