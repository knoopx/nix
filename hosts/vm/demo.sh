#!/bin/bash

# wait until astal-shell is running
echo "Waiting for astal-shell to start..."
while ! pgrep -x ".astal-shell-wr" > /dev/null; do
    sleep 0.5
done
echo "astal-shell is running, starting demo..."

# open launcher
ydotool key 125:1 57:1 125:0 57:0
sleep 0.5

# # hint the user
# ydotool type "Open the launcher with Meta+Space"
# sleep 0.5

# # undo typed text, select all (ctrl-a)
# ydotool key 29:1 30:1 29:0 30:0
# # type "firefox"
# ydotool type "firefox"
# # press enter
# sleep 0.5
# ydotool key 28:1 28:0

# # press control + l to select the URL bar
# sleep 0.5
# ydotool key 29:1 38:1 29:0 38:0
# sleep 0.1
# ydotool type "https://github.com/knoopx/vibeapps"
# sleep 0.1
# # press enter
# ydotool key 28:1 28:0
# sleep 1

# ydotool key 29:1 38:1 29:0 38:0
# ydotool type "Firefox is full styled along with popular sites like GitHub, YouTube, Reddit, etc..."
# sleep 0.5
# ydotool key 1:1 1:0

ydotool key 125:1 20:1 125:0 20:0
sleep 0.5
ydotool type "# uses niri as the window manager"

ydotool key 125:1 20:1 125:0 20:0
sleep 0.5
ydotool type "# enter overview mode with Meta+j"

notify-send "Demo" "Use meta+<arrow keys> to navigate windows, meta+<h/j/k/l> to move focus, and meta+<w> to close windows."
ydotool key 125:1 36:1 125:0 36:0
sleep 0.5

# meta + left
ydotool key 125:1 105:1 125:0 105:0
sleep 0.5

notify-send "Demo" "Move windows around with meta+shift+<arrow keys>"
ydotool key 125:1 42:1 108:1 125:0 42:0 108:0 # meta + shift + down
sleep 0.5

# meta + w
ydotool key 125:1 17:1 125:0 17:0
sleep 0.5

ydotool key 125:1 103:1 125:0 103:0 # meta + up
sleep 0.5

ydotool key 125:1 17:1 125:0 17:0
sleep 0.5

ydotool key 125:1 17:1 125:0 17:0
sleep 0.5
