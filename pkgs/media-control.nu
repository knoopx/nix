#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "media-control" }

def main [action: string] {
  match $action {
    "play-pause" => { playerctl play-pause }
    "next" => { playerctl next }
    "previous" => { playerctl previous }
    "stop" => { playerctl pause }
    _ => {
      print $"Usage: ($program_name) play-pause|next|previous|stop"
      exit 1
    }
  }
}
