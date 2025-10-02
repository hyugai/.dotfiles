# packages
#packages_to_install=(
#    alacritty
#    git
#    npm         # `Mason` (NeoVim) for installation of `bash-language-server` (bashls)
#    gcc gcc-c++ # sources for `clangd` (LSP) to support C/C++
#    neovim
#    fastfetch
#)
#zypper in "${packages_to_install[*]}"

# configuration
ln -s ~/.dotfiles/alacritty ~/.config/alacritty # alacritty
ln -s ~/.dotfiles/nvim ~/.config/nvim           # neovim
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf  # tmux
ln ~/.dotfiles/.clang-format ~/.clang-format    # clang-format

#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh                                                       # rust
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh # miniconda3

# concatenate `PS1` to ~/.bashrc file

#source ~/.bashrc
