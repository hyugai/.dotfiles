#prompt_string
COLOR_END='\e[0m'
BOLD_GREEN="\e[1;032m"
YELLOW="\e[093m"
PS1="${BOLD_GREEN}\u@\h${COLOR_END}: ${YELLOW}[\w]${COLOR_END}\n$ "
#end_prompt_string

export TERM="xterm-256color" # make sure that 4-level colors is supportted for diagnostics
alias e=nvim                 # neovim alias
