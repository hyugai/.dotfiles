#!/bin/bash

# experiment
get_avg_capacity() {
    # determine how many BAT is the laptop currently using?
    # use export -f <fucntion name> to use the function in the `find` command
    # BAT0: internal battery (not removable)
    # BAT1: exernal battery (removable) (recent laptops models only have this)
    echo
}
# end_experiment

main() {
    case "$1" in
    Charging)
        local avg_capacity
        avg_capacity=$(find -L /sys/class/power_supply/BAT1 -maxdepth 1 -type f -name capacity -exec cat '{}' \;)

        echo "#[bold,fg=#5fd7ff] : ${avg_capacity}%" # blue
        ;;
    Discharging)
        local avg_capacity
        avg_capacity=$(find -L /sys/class/power_supply/BAT1 -maxdepth 1 -type f -name capacity -exec cat '{}' \;)

        if ((avg_capacity > 75)); then
            echo "#[bold,fg=#a6e22e]  : ${avg_capacity}%" # green
        elif ((avg_capacity <= 75 && avg_capacity > 50)); then
            echo "#[bold,fg=#a6e22e]  : ${avg_capacity}%" # green
        elif ((avg_capacity <= 50 && avg_capacity > 25)); then
            echo "#[bold,fg=#f1fa8c]  : ${avg_capacity}%" # yellow
        elif ((avg_capacity <= 25)); then
            echo "#[bold,fg=#ff5555]  : ${avg_capacity}" # red
        fi

        ;;
    Full)
        local avg_capacity
        avg_capacity=$(find -L /sys/class/power_supply/BAT1 -maxdepth 1 -type f -name capacity -exec cat '{}' \;)

        echo "#[bold,fg=#a6e22e]  : ${avg_capacity}%" # green
        ;;
    'Not charging')
        local avg_capacity
        avg_capacity=$(find -L /sys/class/power_supply/BAT1 -maxdepth 1 -type f -name capacity -exec cat '{}' \;)

        echo "#[bold,fg=#a6e22e]  : ${avg_capacity}%" # green
        ;;
    esac
}

main "$(find -L /sys/class/power_supply/BAT1 -maxdepth 1 -type f -name status -exec cat '{}' \;)"
