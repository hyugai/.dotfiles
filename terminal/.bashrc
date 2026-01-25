#prompt string
COLOR_END='\e[0m'
BOLD_GREEN="\e[1;032m"
YELLOW="\e[093m"
PS1="${BOLD_GREEN}\u@\h${COLOR_END}: ${YELLOW}\w${COLOR_END}\n$ "

# enable "True Color"
export TERM="xterm-256color"

#aliases
alias e='~/nvim-linux-x86_64.appimage'
