#!/bin/bash

_sum_capacity() {
    local capacity=0
    local BAT_count=0
    echo "hello"

    while [[ $# -gt 0 ]]; do
        capacity=$((capacity + $(cat "$1")))
        BAT_count=$((BAT_count + 1))

        shift
    done
}

say_hi() {
    echo hello
}
export -f say_hi

find -L /sys/class/power_supply/BAT* -maxdepth 1 -type f -name capacity -exec sh -c say_hi '{}' \;
