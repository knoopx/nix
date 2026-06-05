#!/usr/bin/env nu

let cache = $env.HOME | path join ".cache" "inbox.json"
let refresh_interval = 300sec

def fetch-inbox [] {
  gog gmail messages search "in:inbox" --json | from json | get messages
    | select date subject from
    | update date { into datetime | date humanize }
    | update subject { let val = $in; if ($val | str length) > 76 { ($val | str substring --grapheme-clusters 0..75) + '…' } else { $val } }
    | save -f $cache | ignore
}

def main [--tsv, action?: string] {
  if ($action == null or $action != "daemon") and not ($cache | path exists) {
    fetch-inbox
  }

  if $action == "daemon" {
    fetch-inbox
    while true {
      do { sleep $refresh_interval }
      fetch-inbox
    }
  } else if $tsv {
    open $cache | first 10 | select date subject | to tsv
  } else {
    open $cache | table -i false --theme frameless
  }
}

