#!/usr/bin/env nu

let state_dir = ($env.XDG_STATE_HOME? | default ($nu.home-dir + "/.local/state") | path join "kitty")
try { mkdir $state_dir }
let state = ($state_dir | path join "kitty-panel-open")
let panel_match = 'var:panel=yes and state:focused_os_window'

let has_panel = (try { kitten @ ls --match $panel_match | str contains '"pid"' } catch { false })

if $has_panel {
  if ($state | path exists) {
    kitten @ action toggle_layout stack
    try { rm $state }
  } else {
    kitten @ action toggle_layout splits
    try { kitten @ focus-window --match $panel_match }
    "" | save $state
  }
} else {
  try { rm $state }
  try { kitten @ action goto_layout splits }
  try { kitten @ launch --location=hsplit --cwd=current --var panel=yes }
  "" | save $state
}