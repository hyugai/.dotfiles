#!/bin/bash

NEOVIM_DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
NEOVIM_RELEASE_PAGE="https://github.com/neovim/neovim/releases"

# check python virtual env if it's eligible for running the python script
validate_python_env () {
    if ver=$(python --version); then
        num_matches=$(pip list | grep -cE 'bs4|lxml|requests')
        case "$num_matches" in
            3)
                echo Requirements are met!
                ;;
            [0-2])
                echo Python env does not meet requirements! >&2
                exit 1
                ;;
        esac
    else
        echo Python env not found! >&2
        exit 1
    fi

    return
}

# use curl to fetch release page and store it in an shell variable
check_latest_nvim() {
    if validate_python_env; then
        ver=$(python ./neovim/check_latest_nvim.py)
        echo "$ver"
    fi

    return 
}

check_current_nvim () {
    ver=$(nvim --version | grep -oE v[\.[:digit:]]+ | tr -d v)
    if [ "$ver" ]; then
        echo "NeoVim installed! You're using the version $ver"
    else
        echo "No NeoVim's installation found"
    fi

    return
}

dowload_and_install_nvim () {
    return
}

# drop-down menu
echo -ne "Options:
\t0) Quit
\t1) Check the latest stable version of NeoVim from GitHub
\t2) Check the current version of used NeoVim
\t3) Download NeoVim
"

# user's input stored in REPLY
read -p "Select -> "

#
case "$REPLY" in 
    0) exit
        ;;
    1) check_latest_nvim 
        exit
        ;;
    2) check_current_nvim
        exit
        ;;
    3) dowload_and_install_nvim
        exit
        ;;
    *) echo "Invalid entry" >&2
        exit 1
        ;;
esac
