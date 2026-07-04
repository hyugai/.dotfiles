#!/bin/bash

# tmux: window_0 is automatically created if no window is specified when creating new session
#           session
#           /     \
#       window_0  window
#       /   \       \
#   pane    pane    pane

session_name=work
windows_name=(
    main:"$HOME"/projects/diary-latex
    main-dir:"$HOME"/projects/diary-latex
    home:~
)

# create session with specific window
tmux new-session -d -s "$session_name" \
    -n "${windows_name[0]%%:*}" \
    -c "${windows_name[0]##*:}"

# create the other windows
# -t means SESSION TARGET

for ((i = 1; i < "${#windows_name[@]}"; i++)); do
    tmux new-window -t "$session_name" \
        -n "${windows_name[$i]%%:*}" \
        -c "${windows_name[$i]##*:}"
done

# attach to created session
tmux attach -t "$session_name"
