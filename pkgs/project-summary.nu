ls ~/Projects/knoopx
  | where type == dir
  | each { |e|
    let proj = ($env.HOME | path join "Projects" "knoopx" $e.name)

    if (($proj | path join ".git") | path exists) {
      let r = (do { git -C $proj log -1 --pretty="%s%n%ci" } | complete)
      let parts = ($r.stdout | str trim | split row "\n")

      if ($parts | length) >= 2 {
        {
          project:   ($e.name | path split | last 2 | path join),
          commit:    $parts.0,
          date:      ($parts.1 | into datetime | date humanize),
          _sort:     ($parts.1 | into datetime)
        }
      } else {
        ignore
      }
    } else {
      ignore
    }
  }
  | sort-by _sort --reverse
  | first 5
  | reject _sort
  | table -i false --theme frameless
