#!/bin/bash

path="/proc/meminfo"
head -n 3 "$path" | awk '
    NR==1 { memTotal=$2 }
    NR==3 { memAvail=$2 }
    END {printf "%.2f", (memTotal - memAvail) * 100 / memTotal }
'
