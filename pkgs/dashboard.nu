#!/usr/bin/env nu

def main [] {
  let events_tsv = (^events --tsv | complete | get stdout)
  let inbox_tsv = (^inbox --tsv | complete | get stdout)
  let projects_tsv = (^project-summary --tsv | complete | get stdout)

  print (^date '+%A, %B %d, %Y')
  print ""

  print ($events_tsv | from tsv | select date summary | rename " " "  " | table -i false)
  print ""

  print ($inbox_tsv | from tsv | select date from subject | rename " " "  " "   " | table -i false)
  print ""

  print ($projects_tsv | from tsv | select date project commit | rename " " "  " "   " | table -i false)
}
