# .bashrc

# NeoVim
export PATH="$PATH:/opt/nvim-linux64/bin"

# customized "prompt string"
GREEN='\033[0;32m'
RESET='\033[0m'
PS1="\[${GREEN}\u@\h\]${RESET}: [\w]\n\$ "

# user's commands
export PATH="${HOME}/bin:${PATH}"
