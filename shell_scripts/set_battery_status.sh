#!/bin/bash
# → nf-fa-battery_empty
# → nf-fa-battery_quarter
# → nf-fa-battery_half
# → nf-fa-battery_three_quarters
# → nf-fa-battery_full

#debug this function
get_battery_info() {
    local status

    _get_avg_capacity() {
        local capacity=0
        local BAT_count=0

        while [[ $# -gt 0 ]]; do
            capacity=$((capacity + $(cat "$1")))
            BAT_count=$((BAT_count + 1))

            shift
        done

        echo $((capacity / BAT_count))
    }
    export -f _get_avg_capacity

    main() {
        case "$1" in
        Charging)
            local avg_capacity
            avg_capacity=$(find -L /sys/class/power_supply/BAT* -maxdepth 1 -type f -name capacity -exec bash -c '_get_avg_capacity "${0}"' '{}' +)

            echo " ${avg_capacity}%"
            ;;
        Discharging)
            local avg_capacity
            avg_capacity=$(find -L /sys/class/power_supply/BAT* -maxdepth 1 -type f -name capacity -exec bash -c '_get_avg_capacity "${0}"' '{}' +)

            if ((avg_capacity >= 75)); then
                echo "  ${avg_capacity}%"
            elif ((avg_capacity >= 50)); then
                echo "  ${avg_capacity}%"
            elif ((avg_capacity >= 25)); then
                echo "  ${avg_capacity}"
            else
                echo "  ${avg_capacity}%"
            fi

            echo "${avg_capacity}%"
            ;;
        Full)
            echo '  100%'
            ;;
        esac
    }

    status=$(find -L /sys/class/power_supply/BAT* -maxdepth 1 -type f -name status -exec cat '{}' \;)
    main "$status"
}
get_battery_info
