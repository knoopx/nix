#!/usr/bin/env nu

let cache = $env.HOME | path join "Documents" "personal" "mail-inbox.tsv"
let refresh_interval = 300sec

def fetch-inbox [] {
  let new = (gog gmail messages search "in:inbox" --json | from json | get messages
    | update labels { $in | str join "," })

  let existing = (if ($cache | path exists) { open $cache } else { [] })

  let new_ids = ($new | get id)
  $new | append ($existing | where id in $new_ids) | uniq-by id | to tsv | save -f $cache | ignore
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
    open $cache | first 10 | to tsv
  } else {
    open $cache | table -i false --theme frameless
  }
}

