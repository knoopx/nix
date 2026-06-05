#!/usr/bin/env nu

def fill-to [field: string, target: int] {
  $in | from tsv | update $field {|r|
    let val = ($r | get $field)
    let clip = (if ($val | str length) > $target { $val | str substring 0..$target } else { $val })
    let len = ($clip | str length)
    if $len >= $target { $clip } else {
      let pad = (0..($target - $len - 1) | each {|| " "} | str join)
      $"($clip)($pad)"
    }
  } | to tsv
}

def build-panel [title: string, accent: string, tsv: string] {
  let header = (^gum style --foreground $accent --bold $title)
  let table = ($tsv | ^gum table -s "\t" -p --border rounded | ^gum style --foreground 243)
  $"($header)\n($table)"
}

def main [] {
  # Fetch TSV data
  let events_tsv = (^events --tsv | complete | get stdout)
  let inbox_tsv = (^inbox --tsv | complete | get stdout)
  let projects_tsv = (^project-summary --tsv | complete | get stdout)

  # Logo left + date right, vertically centered
  let logo = (open $env.LOGO_PATH | str trim -r)
  let cols = (^tput cols | into int)
  let logo_w = 46
  let date_w = ($cols - $logo_w)
  let date_line = (^gum style --align right --width $date_w --foreground 245 (^date '+%A, %B %d, %Y'))
  print (^gum join --horizontal --align center $logo $date_line)
  print ""

  let half = ($cols / 2 | into int)

  let colw_ev = ($half - 14 - 3 | into int)
  let colw_pr = ($half - 15 - 20 - 7 | into int)
  let colw_in = ($cols - 14 - 5 | into int)

  let panel_events = (build-panel "events" "#ff628c" ($events_tsv | fill-to "summary" $colw_ev))
  let panel_projects = (build-panel "projects" "#a5ff90" ($projects_tsv | fill-to "commit" $colw_pr))
  print (^gum join --horizontal $panel_events $panel_projects)

  print ""

  print (build-panel "inbox" "#80fcff" ($inbox_tsv | fill-to "subject" $colw_in))
}
