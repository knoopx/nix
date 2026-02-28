#!/usr/bin/env nu

let window_width = 600
let window_height = 340
let tile_padding = 7
let margin = 12
let stack_gap = 6
let fifo_path = "/tmp/window-control.fifo"

def get-screen-size [] {
  let workspaces = (^niri msg --json workspaces | from json)
  let focused_output = ($workspaces | where is_focused == true | get output.0)
  let outputs = (^niri msg --json outputs | from json)
  let output_data = ($outputs | get $focused_output)
  { width: ($output_data.logical | get width), height: ($output_data.logical | get height) }
}

def restack [managed: list<record<id: int, width: float, height: float, fullscreen: bool>>] {
  if ($managed | length) == 0 { return }
  let screen = (get-screen-size)
  $managed | enumerate | each { |it|
    let tile_w = $window_width + $tile_padding
    let tile_h = $window_height + $tile_padding
    let x = $screen.width - $tile_w - $margin
    let y = $screen.height - $tile_h - $margin - ($it.index * ($tile_h + $stack_gap))
    ^niri msg action move-floating-window --id ($it.item.id | into string) --x $x --y $y
  }
}

def main [action: string, ...args: string] {
  match $action {
    "float-to-corner" => {
      let windows = (^niri msg --json windows | from json)
      let focused = ($windows | where is_focused == true | first)

      if $focused.is_floating {
        $"unfloat ($focused.id)\n" | save -a $fifo_path
      } else {
        let screen = (get-screen-size)
        let size = $focused.layout.window_size
        let is_fullscreen = (($size | get 0 | into int) == $screen.width and ($size | get 1 | into int) == $screen.height)
        let win_w = ($focused.layout.window_size | get 0)
        let win_h = ($focused.layout.window_size | get 1)
        $"float ($focused.id) ($win_w) ($win_h) ($is_fullscreen)\n" | save -a $fifo_path
      }
    }
    "fullscreen" => {
      let focused = (^niri msg --json focused-window | from json)
      $"fullscreen ($focused.id)\n" | save -a $fifo_path
    }
    "webcam" => {
      let windows = (^niri msg --json windows | from json)
      let existing = ($windows | where title == "/dev/video0")

      if ($existing | length) > 0 {
        let wid = ($existing | first | get id)
        ^niri msg action close-window --id ($wid | into string)
      } else {
        ^bash -c "nohup ffplay -fflags nobuffer -analyzeduration 0 -video_size 640x480 /dev/video0 > /dev/null 2>&1 &"
      }
    }
    "daemon" => {
      if ($fifo_path | path exists) { rm $fifo_path }
      ^mkfifo $fifo_path

      ^tail -f $fifo_path
        | lines
        | each { |line| $"cmd:($line)" }
        | interleave { ^niri msg --json event-stream | lines | each { |line| $"niri:($line)" } }
        | reduce -f [] { |msg, managed|
            if ($msg | str starts-with "cmd:") {
              let cmd = ($msg | str substring 4..)
              let parts = ($cmd | split row " ")
              let action = ($parts | get 0)

              if $action == "float" {
                let wid = ($parts | get 1 | into int)
                let tile_w = ($parts | get 2 | into float)
                let tile_h = ($parts | get 3 | into float)
                let is_fs = ($parts | get 4) == "true"

                let new_managed = ($managed | append { id: $wid, width: $tile_w, height: $tile_h, fullscreen: $is_fs })

                ^niri msg action toggle-window-floating --id ($wid | into string)
                ^niri msg action set-window-width --id ($wid | into string) $window_width
                ^niri msg action set-window-height --id ($wid | into string) $window_height

                restack $new_managed
                $new_managed

              } else if $action == "unfloat" {
                let wid = ($parts | get 1 | into int)
                let entry = ($managed | where id == $wid)
                let new_managed = ($managed | where id != $wid)

                ^niri msg action toggle-window-floating --id ($wid | into string)

                if ($entry | length) > 0 {
                  let geo = ($entry | first)
                  if $geo.fullscreen {
                    ^niri msg action fullscreen-window --id ($wid | into string)
                  } else {
                    ^niri msg action set-window-width --id ($wid | into string) ($geo.width | math round | into int | into string)
                    ^niri msg action set-window-height --id ($wid | into string) ($geo.height | math round | into int | into string)
                  }
                }

                restack $new_managed
                $new_managed

              } else if $action == "fullscreen" {
                let wid = ($parts | get 1 | into int)
                ^niri msg action fullscreen-window --id ($wid | into string)
                restack $managed
                $managed

              } else {
                $managed
              }

            } else if ($msg | str starts-with "niri:") {
              let payload = ($msg | str substring 5..)
              let event = ($payload | from json)
              let event_type = ($event | columns | first)

              if $event_type == "WindowClosed" {
                let closed_id = $event.WindowClosed.id
                if ($managed | any { |entry| $entry.id == $closed_id }) {
                  let new_managed = ($managed | where id != $closed_id)
                  restack $new_managed
                  $new_managed
                } else {
                  $managed
                }

              } else if $event_type == "WorkspaceActivated" and $event.WorkspaceActivated.focused {
                if ($managed | length) > 0 {
                  let workspaces = (^niri msg --json workspaces | from json)
                  let focused_ws = ($workspaces | where is_focused == true | first)
                  $managed | each { |entry|
                    ^niri msg action move-window-to-workspace --window-id ($entry.id | into string) --focus false ($focused_ws.idx | into string)
                  }
                }
                $managed

              } else {
                $managed
              }

            } else {
              $managed
            }
          }
    }
    _ => {
      print "Usage: window-control <float-to-corner|daemon|webcam>"
      exit 1
    }
  }
}
