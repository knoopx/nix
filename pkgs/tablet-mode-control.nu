#!/usr/bin/env nu

let program_name = if $env.PROGRAM_NAME? != null { $env.PROGRAM_NAME } else { "tablet-mode-control" }

def main [action: string] {
  match $action {
    "on" => { gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true }
    "off" => { gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false }
    _ => {
      print $"Usage: ($program_name) on|off"
      exit 1
    }
  }
}
