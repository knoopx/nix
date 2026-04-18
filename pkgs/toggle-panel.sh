#!/bin/sh
state="${XDG_RUNTIME_DIR:-/tmp}/kitty-panel-open"

if ! kitten @ ls 2>/dev/null | grep -q '"title": "panel"'; then
	# No panel - create and focus it
	kitten @ launch --location=hsplit --cwd=current --title=panel
	touch "$state"
elif [ -f "$state" ]; then
	# Panel is visible - hide it (preserves session)
	kitten @ focus-window --match 'not title:panel' 2>/dev/null
	kitten @ action toggle_layout stack
	rm -f "$state"
else
	# Panel is hidden - show and focus it
	kitten @ action toggle_layout stack
	kitten @ focus-window --match title:panel
	touch "$state"
fi
