##!/usr/bin/env bash

SESSION="sudo_code"

# format: "window-name:directory"
root="$HOME/projects/sudo_code_2026-group_9"

windows=(
    "root:${root}"
    "dataset:${root}/dataset"
)

# Create session using the first directory
first_name="${windows[0]%%:*}"
first_dir="${windows[0]#*:}"

tmux new-session -d -s "$SESSION" -n "$first_name" -c "$first_dir"

# Create remaining windows
for item in "${windows[@]:1}"; do
    name="${item%%:*}"
    dir="${item#*:}"

    tmux new-window \
        -t "$SESSION" \
        -n "$name" \
        -c "$dir"
done

tmux select-window -t "$SESSION:1"
tmux attach-session -t "$SESSION"
