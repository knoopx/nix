#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "session-control" }

def main [action: string] {
  match $action {
    "lock" => { hyprlock }
    "logout" => { niri msg action quit }
    "suspend" => { systemctl suspend }
    "hibernate" => { systemctl hibernate }
    "reboot" => { systemctl reboot }
    "poweroff" => { systemctl poweroff }
    _ => {
      print $"Usage: ($program_name) lock|logout|suspend|hibernate|reboot|poweroff"
      exit 1
    }
  }
}
