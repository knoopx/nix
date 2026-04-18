#!/usr/bin/env nu
let cache = $env.HOME | path join ".cache" "inbox.json"
let ttl = 300sec

let cache_hit = ($cache | path exists) and ((ls -s $cache | get modified | last)  | into datetime) > ((date now) - $ttl)

if not $cache_hit {
 gog gmail messages search "in:inbox" --json | from json | get messages | select date subject from | update date { into datetime | date humanize } | save -f $cache
}

open $cache | table -i false --theme frameless

