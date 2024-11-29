#!/bin/bash

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim /opt/nvim-linux64
tar -C /opt -xzf nvim-linux64.tar.gz 
rm -rf nvim-linux64.tar.gz 

nvim_path=$(grep 'export PATH="$PATH:/opt/nvim-linux64/bin"' ~/.bashrc | wc -l)
if [ nvim_path = 1 ]; then
	echo 'path of nvim has already existed!'
else
	echo 'export PATH="$PATH:/opt/nvim-linux64/bin"' >> ~/.bashrc
	source ~/.bashrc
fi
