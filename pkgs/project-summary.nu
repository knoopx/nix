#!/usr/bin/env nu

def fetch-projects [] {
  ls ~/Projects/knoopx
    | where type == dir
    | each { |e|
      let proj = ($env.HOME | path join "Projects" "knoopx" $e.name)

      if (($proj | path join ".git") | path exists) {
        let date_r = (do { git -C $proj log -1 --format="%ci" } | complete)
        let commit_r = (do { git -C $proj log -1 --format="%s" --grep="." } | complete)

        if $date_r.exit_code == 0 {
          let date_str = ($date_r.stdout | str trim)
          let commit_raw = ($commit_r.stdout | str trim)
          let commit_msg = (if ($commit_raw | is-empty) { "(no changes)" } else { $commit_raw })

          if ($date_str | is-empty) {
            ignore
          } else {
            {
              date:      ($date_str | into datetime | date humanize),
              project:   ($e.name | path split | last 2 | path join),
              commit:    $commit_msg,
              _sort:     ($date_str | into datetime)
            }
          }
        } else {
          ignore
        }
      } else {
        ignore
      }
    }
    | sort-by _sort --reverse
    | first 10
    | reject _sort
}

def main [--tsv] {
  let data = fetch-projects

  if $tsv {
    $data | to tsv
  } else {
    $data | table -i false --theme frameless
  }
}
