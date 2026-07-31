tmux new-session \; \
    send-keys "npm run css:dev" C-m \; \
    split-window -v \; \
    send-keys "uvx --with reloadserver python3 -m reloadserver" C-m
