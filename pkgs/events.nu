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

def main [--tsv, action?: string] {
  if ($action == null or $action != "daemon") and not ($cache | path exists) {
    fetch-events
  }

  if $action == "daemon" {
    fetch-events
    while true {
      do { sleep $refresh_interval }
      fetch-events
    }
  } else if $tsv {
    open $cache | first 10 | select date summary | to tsv
  } else {
    open $cache | table -i false --theme frameless
  }
}
