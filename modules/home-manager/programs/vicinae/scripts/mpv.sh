#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Play with mpv
# @vicinae.description Play a URL or file with mpv media player
# @vicinae.icon 🎬
# @vicinae.mode silent
# @vicinae.keywords ["video", "media", "player", "stream", "youtube"]
# @vicinae.argument1 { "type": "text", "placeholder": "URL or file path" }

setsid -f /etc/profiles/per-user/knoopx/bin/mpv "$@" >/dev/null 2>&1 </dev/null
