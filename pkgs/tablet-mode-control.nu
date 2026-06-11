#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "tablet-mode-control" }

def main [action: string] {
  match $action {
    "toggle" => {
      let pids = (pgrep -x wvkbd-mobintl | str trim)
      if $pids != "" {
        let pid = ($pids | split row "\n" | first | into int)
        ^kill -s 34 $pid
      } else {
        systemctl --user start wvkbd.service
      }
    }
    "on" => {
      let pids = (pgrep -x wvkbd-mobintl | str trim)
      if $pids == "" {
        systemctl --user start wvkbd.service
      }
    }
    "off" => {
      let pids = (pgrep -x wvkbd-mobintl | str trim)
      if $pids != "" {
        let pid = ($pids | split row "\n" | first | into int)
        ^kill -s 34 $pid
      }
    }
    _ => {
      print $"Usage: ($program_name) toggle|on|off"
      exit 1
    }
  }
}
