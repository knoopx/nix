#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "display-control" }

def main [action: string] {
  match $action {
    "power-off-monitors" => { niri msg action power-off-monitors }
    "power-on-monitors" => { niri msg action power-on-monitors }
    _ => {
      print $"Usage: ($program_name) power-off-monitors|power-on-monitors"
      exit 1
    }
  }
}
