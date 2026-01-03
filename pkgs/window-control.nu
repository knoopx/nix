#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "window-control" }

let window_width = 600
let window_height = 340
let margin = 30

def main [action: string] {
  match $action {
    "float-to-corner" => {
      let windows = (^niri msg --json windows | from json)
      let is_floating = ($windows | where is_focused == true | get is_floating.0)

      if $is_floating == true {
        ^niri msg action toggle-window-floating
        ^niri msg action set-column-width 100%
        ^niri msg action reset-window-height
      } else {
        let workspaces = (^niri msg --json workspaces | from json)
        let focused_output = ($workspaces | where is_focused == true | get output.0)
        let outputs = (^niri msg --json outputs | from json)
        let output_data = ($outputs | get $focused_output)
        let width = ($output_data.logical | get width)
        let height = ($output_data.logical | get height)

        let x = $width - $window_width - $margin
        let y = $height - $window_height - $margin

        ^niri msg action toggle-window-floating
        ^niri msg action set-window-width $window_width
        ^niri msg action set-window-height $window_height
        ^niri msg action move-floating-window --x $x --y $y
      }
    }
    _ => {
      print $"Usage: ($program_name) float-to-corner"
      exit 1
    }
  }
}
