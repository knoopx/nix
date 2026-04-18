#!/usr/bin/env nu
let cache = $env.HOME | path join ".cache" "events.json"
let ttl = 300sec

let cache_hit = ($cache | path exists) and ((ls -s $cache | get modified | last)  | into datetime) > ((date now) - $ttl)
if not $cache_hit {
  gog calendar events --days 30 --json | from json | get events
    | each {
        let s = $in.start;
        let sd = try { $s.date } catch { $s.dateTime };
        { "date": $sd, summary: $in.summary, organizer: $in.organizer.email, status: $in.status }
      }
    | update "date" { into datetime | date humanize } | save -f $cache
}

open $cache | table -i false --theme frameless
