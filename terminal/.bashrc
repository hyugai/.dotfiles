#prompt string
#GREEN="\e[32m\033[1m" # bold green
#YELLOW="\e[093m"
#RESET="\e[0m"
#PS1="${GREEN}\u@\h${RESET}: ${YELLOW}\w${RESET}\n$ "

# enable "True Color"
export TERM="xterm-256color"

#aliases
alias e='~/nvim-linux-x86_64.appimage'

# opencode
export PATH=/home/cookies/.opencode/bin:$PATH

# Added by Antigravity CLI installer
export PATH="/home/cookies/.local/bin:$PATH"
. "$HOME/.cargo/env"

# bash inline editing
export VISUAL=vim
export EDITOR=vim
