# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# NeoVim
export PATH="$PATH:/opt/nvim-linux64/bin"

# customized "prompt string"
GREEN='\033[0;32m'
RESET='\033[0m'
PS1="\[${GREEN}\u@\h\]${RESET}: [\w]\n\$ "

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/noob/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/noob/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/noob/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/noob/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# rust 
. "$HOME/.cargo/env"

# user's command
export PATH="${HOME}/bin:${PATH}"
