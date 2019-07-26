https://tmuxcheatsheet.com/

# Config & defaults
```bash
# Config file
~/.tmux.conf

# Defaults
Prefix=<Ctrl+b>
```

# Sessions
```bash
# start tmux session
tmux #new-session

# start named tmux session
tmux new -s ansible

# kill tmux session
tmux kill-session -t myname

# (re)name session
Prefix + $

# detach tmux session
Ctrl+b, d

# attach tmux session
tmux attach

# Switch sessions
Prefix + ( 	# Switch the attached client to the previous session.
Prefix + ) 	# Switch the attached client to the next session.
Prefix + L 	# Switch the attached client back to the last session.
Prefix + s 	# Select a new session for the attached client interactively.
    
# List all clients
tmux list-clients
```

# Panes
```bash
Prefix + %  # horizontal split
Prefix + "  # vertical split

Prefix + o  # swap panes
Prefix + q  # show pane numbers
Prefix + x  # kill pane
Prefix + ⍽  # toggle between layouts

Prefix + ;  # toggle between last active windows
Prefix + (arrow) # move to different pane
```
