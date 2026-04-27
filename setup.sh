#!/bin/bash

# ===== Terminal ===== 
#ln -s ~/.dotfiles/terminal/alacritty.toml ~/.config/alacritty.toml
ln -s ~/.dotfiles/terminal/.bashrc ~/.bashrc
ln -s ~/.dotfiles/terminal/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/terminal/foot ~/.config/foot

# ===== Text Editor ===== 
ln -s ~/.dotfiles/text-editor/nvim ~/.config/nvim
ln -s ~/.dotfiles/text-editor/.clang-format ~/.clang-format
ln -s ~/.dotfiles/text-editor/clangd ~/.config/clangd

# ===== GitHub ===== 
# git config --global user.email <email> && git config --global user.name <name>
# ssh-keygen -t ed25519 -C <email>
# cat .ssh/id_ed25519.pub && xsel -ib

# ===== Books ===== 
ln -s ~/bkup/books ~/Documents/books
