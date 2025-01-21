#!/bin/bash

# modules
validate_python_env() {
    return
}

# main
current=$(sudo dmidecode -s bios-version | sed 's/.*\.//')
# fix here: make it runable from any given directory
mapfile -t latest_info < <(python supporting.py)

shopt -s extglob
case "${latest_info[0]}" in
    error)
        echo "error: Failed to fetch web page!" >&2
        exit 1
        ;;

    "$current")
        echo "The BIOS is up-to-date!"
        ;;

    *)
        if (("$current" < "${latest_info[0]}")); then
            echo "The BIOS is outdated!"
            read -rp "Do you want to download the latest BIOS? [Y/n]: "
            case "${REPLY,,}" in
                y)
                    curl -o archive.zip "${latest_info[1]}"
                    ;;
                n)
                    exit 0
                    ;;
                *)
                    echo "error: Invalid option!" >&2
                    exit 1
                    ;;
            esac
        else
            echo "error: Wrong format or something else! (${latest_info[0]})"
        fi
        ;;
esac
