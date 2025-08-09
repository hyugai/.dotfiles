COLOR_END='\e[0m'
BOLD_GREEN="\e[1;032m"
YELLOW="\e[093m"
PS1="${BOLD_GREEN}\u@\h${COLOR_END}: ${YELLOW}[\w]${COLOR_END}\n$ "

# make sure that 4-level colors is supportted for diagnostics
export TERM="xterm-256color"
