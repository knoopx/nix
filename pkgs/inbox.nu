#!/usr/bin/env nu

let cache = $env.HOME | path join ".cache" "inbox.json"
let refresh_interval = 300sec

def fetch-inbox [] {
  gog gmail messages search "in:inbox" --json | from json | get messages
    | select date subject from
    | update date { into datetime | date humanize }
    | save -f $cache | ignore
}

def main [action?: string] {
  let action = (if $action != null { $action } else { "show" })

  match $action {
    "daemon" => {
      # Initial fetch
      fetch-inbox

      # Periodic refresh loop
      while true {
        do { sleep $refresh_interval }
        fetch-inbox
      }
    }

    "show" => {
      if not ($cache | path exists) { fetch-inbox }
      open $cache | table -i false --theme frameless
    }

    _ => {
      print "Usage: inbox [daemon|show]"
      exit 1
    }
  }
}

