#!/usr/bin/env nu

# Wait until astal-shell is running
print "Waiting for astal-shell to start..."
while not (pgrep -x ".astal-shell-wr" | is-empty) {
    sleep 0.5sec
}
print "astal-shell is running, starting demo..."

# Open launcher
ydotool key 125:1 57:1 125:0 57:0
sleep 0.5sec

ydotool key 125:1 20:1 125:0 20:0
sleep 0.5sec
ydotool type "# uses niri as the window manager"

ydotool key 125:1 20:1 125:0 20:0
sleep 0.5sec
ydotool type "# enter overview mode with Meta+j"

notify-send "Demo" "Use meta+<arrow keys> to navigate windows, meta+<h/j/k/l> to move focus, and meta+<w> to close windows."
ydotool key 125:1 36:1 125:0 36:0
sleep 0.5sec

# meta + left
ydotool key 125:1 105:1 125:0 105:0
sleep 0.5sec

notify-send "Demo" "Move windows around with meta+shift+<arrow keys>"
ydotool key 125:1 42:1 108:1 125:0 42:0 108:0 # meta + shift + down
sleep 0.5sec

# meta + w
ydotool key 125:1 17:1 125:0 17:0
sleep 0.5sec

ydotool key 125:1 103:1 125:0 103:0 # meta + up
sleep 0.5sec

ydotool key 125:1 17:1 125:0 17:0
sleep 0.5sec

ydotool key 125:1 17:1 125:0 17:0
sleep 0.5sec
