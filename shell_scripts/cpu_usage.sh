#!/bin/bash

sum_array() {
    local total=0
}
main() {
    local total
    local path="/proc/stat"

    mapfile -t pre < <(head -n 1 "$path")
    sleep 1
    mapfile -t post < <(head -n 1 "$path")
}

main
