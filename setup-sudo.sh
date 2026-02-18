#!/bin/bash

# gcc-c++ for LSP support in NeoVim
# npm to install `pyright` in NeoVim
# fcitx5-unikey for Vietnamese typing
zypper in gcc-c++ npm fcitx5-unikey xsel

# symlink for systemd service -> limit battery charging
ln -s ~/.dotfiles/battery-threshold.service /etc/systemd/system/battery-threshold.service
