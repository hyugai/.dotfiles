#!/bin/bash

# gcc-c++ for LSP support in NeoVim
# npm to install `pyright` in NeoVim
zypper in gcc-c++ npm

# symlink for systemd service -> limit battery charging
ln -s ~/.dotfiles/battery-threshold.service /etc/systemd/system/battery-threshold.service
