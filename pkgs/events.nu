#!/usr/bin/env nu

let cache = $env.HOME | path join ".cache" "events.json"
let refresh_interval = 300sec

def fetch-events [] {
  gog calendar events --days 30 --json | from json | get events
    | each {
        let s = $in.start;
        let sd = try { $s.date } catch { $s.dateTime };
        { "date": $sd, summary: $in.summary, organizer: $in.organizer.email, status: $in.status }
      }
    | update "date" { into datetime | date humanize } | save -f $cache | ignore
}

def main [action?: string] {
  let action = (if $action != null { $action } else { "show" })

  match $action {
    "daemon" => {
      # Initial fetch
      fetch-events

      # Periodic refresh loop
      while true {
        do { sleep $refresh_interval }
        fetch-events
      }
    }

    "show" => {
      if not ($cache | path exists) { fetch-events }
      open $cache | table -i false --theme frameless
    }

    _ => {
      print "Usage: events [daemon|show]"
      exit 1
    }
  }
}
