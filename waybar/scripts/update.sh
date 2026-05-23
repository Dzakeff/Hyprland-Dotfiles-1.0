#!/bin/bash

kitty --hold sh -c '
yay -Syu
flatpak update
'
