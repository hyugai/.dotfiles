# disable visual bell (bug: screen flicker in Git Bash)
set bell-style none

# use packages installed by scoop
export PATH="$PATH:$USERPROFILE/scoop/shims"

# bug: "ln -s" creates a copy instead of actual symbolic link
export MSYS=winsymlinks:nativestrict 

alias e="/c/tools/neovim/nvim-win64/bin/nvim"
