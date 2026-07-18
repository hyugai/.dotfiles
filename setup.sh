#!/bin/bash
DOTFILES_DIR="${HOME}/.dotfiles"

prompt-yes-no-question() {
    while true; do
        read -rp "Enter [Y/n] > " respose

        response="${respose,,}"
        response="${respose:-y}"

        if [ "$response" == "y" ]; then
            return 0
        elif [ "$response" == "n" ]; then
            return 1
        fi
    done
}

create-symlink() {
    if [ -L "$2" ]; then # exists and is a symbolic link
        echo "Link exists. Do you want to re-create it?"

        if prompt-yes-no-question; then
            echo "Deleting..."
            rm "$2"

            echo "Re-creating symlink..."
            ln -s "$1" "$2"

        else
            echo "Exiting..."
        fi

    else
        echo "Creating..."
        ln -s "$src_path" "$destination_path"
    fi
}

set-neovim-config() {
    local src_path destination_path

    src_path="${DOTFILES_DIR}/text-editor-config/nvim"
    destination_path="${HOME}/.config/nvim"

    create-symlink "$src_path" "$destination_path"
}

set-tmux-config() {
    local src_path destination_path

    src_path="${DOTFILES_DIR}/terminal-config/.tmux.conf"
    destination_path="${HOME}/.tmux.conf"

    create-symlink "$src_path" "$destination_path"
}

set-bash-config() {
    local src_path destination_path

    src_path="${DOTFILES_DIR}/terminal-config/.bashrc"
    destination_path="${HOME}/.bashrc"

    create-symlink "$src_path" "$destination_path"
}

copy-latex-template() {
    local src_path

    src_path="${DOTFILES_DIR}/latex-template"

    readarray -t templates < <(ls "$src_path")

    # list enumerated templates
    # 0. template-name
    for ((i = 0; i < "${#templates[@]}"; ++i)); do
        echo "${i}. ${templates[i]}"
    done

    # choose template by number
    while true; do
        read -rp "Enter choice > " choice
        if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -lt "${#templates[@]}" ]]; then
            break
        fi
    done

    # where to copy template
    while true; do
        read -rp "Enter destination > " destination_path

        destination_path="${destination_path/#\~/${HOME}}"
        if [ -d "$destination_path" ]; then
            break
        fi
    done

    # get unique name for copied template
    while true; do
        read -rp "Enter name > " name

        name="${respose:-${templates[choice]}}" # default

        if [ -d "${destination_path}/${name}" ]; then
            echo "Name already exists!!!"
            continue
        fi

        break
    done
}
