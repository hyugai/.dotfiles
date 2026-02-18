#!/bin/bash

# if `npm` is not available, install it
read -rp "Enter package manager's name: "
"$REPLY" install npm

# chmod +x battery-threshold.service -> ensure other users can execute this file
ln -s ~/.dotfiles/battery-threshold.service /etc/systemd/system/battery-threshold.service
