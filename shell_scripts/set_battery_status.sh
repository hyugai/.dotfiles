#!/bin/bash
# → nf-fa-battery_empty
#
# → nf-fa-battery_quarter
#
# → nf-fa-battery_half
#
# → nf-fa-battery_three_quarters
#
# → nf-fa-battery_full
# (nf-fa-plug) → plug
#
# (nf-fa-bolt) → bolt

#debug this function
get_battery_info() {
    local status

    _sum_capacity() {
        local capacity=0
        local BAT_count=0
        echo "hello"

        while [[ $# -gt 0 ]]; do
            capacity=$((capacity + $(cat "$1")))
            BAT_count=$((BAT_count + 1))

            shift
        done

        echo $((capacity / BAT_count))
    }

    say_hi() {
        echo hello
    }

    main() {
        case "$1" in
        Charging)
            echo ""
            ;;
        Discharging)
            local avg_capacity
            # bug's here
            find -L /sys/class/power_supply/BAT* -maxdepth 1 -type f -name capacity -exec bash -c say_hi '{}' +
            #echo "$avg_capacity"
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
