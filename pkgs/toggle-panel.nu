#!/usr/bin/env nu

# The auxiliary panel is one per OS window (not one per tab). Its open/closed
# state is tracked per window via the Kitty user variable `panel_open` on the
# window's main window, instead of a single global state file. Each OS window
# keeps independent panel state.

# Kitty `var:` match queries are UNANCHORED regexes: the part before `=` is a
# regex over the variable name, the part after `=` over the value, so
# `var:panel=yes` also matches a window flagged `panel_open=yes`. Anchor both
# sides for an exact match.
let panel_match = 'var:^panel$=^yes$ and state:focused_os_window'
let main_match = 'state:focused_os_window and not var:^panel$=^yes$'

# panel_open lives in the MAIN WINDOW's user_vars (window level). `kitten @ ls`
# OS-window records carry no user_vars field, so read the flag via the
# set-user-vars print mode: no NAME=VALUE args -> prints the matched windows'
# variables one name=value per line (empty when the window has none).
let vars_out = (try { kitten @ set-user-vars --match $main_match } catch { "" })
let panel_open = (if ($vars_out | str contains "panel_open=yes") { "yes" } else { "no" })

if $panel_open == "yes" {
    # Close: move focus to the main window, clear the flag, hide the panel.
    try { kitten @ focus-window --match $main_match }
    kitten @ set-user-vars --match $main_match panel_open=no
    kitten @ action goto_layout stack
} else {
    # Open: launch a panel if this window has none, flag it, show and focus it.
    let has_panel = (try { kitten @ ls --match $panel_match | str contains '"pid"' } catch { false })
    if not $has_panel {
        kitten @ action goto_layout splits
        kitten @ launch --location=hsplit --cwd=current --var panel=yes
    }
    try { kitten @ focus-window --match $main_match }
    kitten @ set-user-vars --match $main_match panel_open=yes
    kitten @ action goto_layout splits
    try { kitten @ focus-window --match $panel_match }
}
