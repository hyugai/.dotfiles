#!/bin/bash

#debug this function
get_battery_info() {
    local BAT_count=0
    local total_elementary_capacities=0
    local capacity

    for i in /sys/class/power_supply/BAT*; do
        BAT_count=$((BAT_count + 1))
        total_elementary_capacities=$((total_elementary_capacities + $(cat "$i"/capacity)))
    done

    capacity=$((total_elementary_capacities / BAT_count))

    echo $capacity
}
get_battery_info
