#!/bin/bash

# gcc-c++ for LSP support in NeoVim
# npm to install `pyright` in NeoVim
# fcitx5-unikey for Vietnamese typing
zypper in gcc-c++ npm fcitx5-unikey xsel

#
cp ~/.dotfiles/battery-threshold.service /etc/systemd/system/
