#!/bin/bash

#terminal
ln -s ~/.dotfiles/terminal/alacritty.toml ~/.config/alacritty.toml
ln -s ~/.dotfiles/terminal/.bashrc ~/.bashrc
ln -s ~/.dotfiles/terminal/.tmux.conf ~/.tmux.conf

#editor
ln -s ~/.dotfiles/text-editor/nvim ~/.config/nvim
ln -s ~/.dotfiles/text-editor/.clang-format ~/.clang-format
ln -s ~/.dotfiles/text-editor/clangd ~/.config/clangd

# git config --global user.email <email> && git config --global user.name <name>
# ssh-keygen -t ed25519 -C <email>
# cat .ssh/id_ed25519.pub && xsel -ib

#books
ln -s ~/bkup/books ~/Documents/books
