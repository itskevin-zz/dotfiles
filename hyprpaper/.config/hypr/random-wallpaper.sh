#!/bin/bash

# define wallpaper diretory
dir=~/Pictures/TSOTG

# selects a random wallpaper from directory, -type f lists all files. shuf -n 1 randomly selects one file from the list

background=$(find "$dir" -type f | shuf -n 1)

# adding sleep to prevent race condition and let hyprpaper load first

sleep 1

# preload selected file & set preloaded image
hyprctl hyprpaper preload "$background"
hyprctl hyprpaper wallpaper "all,$background"

# pause briefly
sleep 1

# unload all unused
hyprctl hyprpaper unload unused
