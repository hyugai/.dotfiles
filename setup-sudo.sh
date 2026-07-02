#!/bin/bash

# gcc-c++ for LSP support in NeoVim
# npm to install `pyright` in NeoVim
# fcitx5-unikey for Vietnamese typing
zypper in \
    gcc-c++ \
    npm \
    fcitx5-unikey \
    xsel \
    foot \
    git lazygit \
    texlive-scheme-full

cp ~/.dotfiles/system/battery-threshold.service /etc/systemd/system/
sudo systemctl enable battery-threshold.service
