#!/bin/bash

#tmux: window_0 is automatically created if no window is specified when creating new session
#           session
#           /     \
#       window_0  window
#       /   \       \
#   pane    pane    pane

# C-b d -> detach from session
# tmux attach -t $session_name
# tmux kill-session -t $session_name

session_name=work
windows_name=(
    main:"$HOME"/projects/diary-latex:e
    git:"$HOME"/projects/diary-latex:lazygit
    cmd:"$HOME":
)

#create the other windows
#-t means SESSION TARGET
for ((i = 0; i < "${#windows_name[@]}"; ++i)); do
    #
    win_name="${windows_name[$i]%%:*}"
    t="${windows_name[$i]%:*}"
    dir_to_change="${t#*:}"

    if ((i == 0)); then
        tmux new-session -d -s "$session_name" \
            -n "${win_name}" \
            -c "${dir_to_change}"
    else
        tmux new-window -t "$session_name" \
            -n "$win_name" \
            -c "$dir_to_change"
    fi

    #
    cmd_to_send="${windows_name[$i]##*:}"
    if [ "${#cmd_to_send}" -ne 0 ]; then
        tmux send-keys -t "${session_name}:${win_name}" "$cmd_to_send" C-m
    fi
done

#attach to created session
tmux attach -t "$session_name"
