#!/usr/bin/env nu

let projects_dir = ($env.HOME | path join "Projects")
let documents_dir = ($env.HOME | path join "Documents")

def has-visible-entries [dir: string] {
  if not ($dir | path exists) {
    return false
  }

  ((ls $dir | length) > 0)
}

def visible-subdirs [dir: string] {
  if not ($dir | path exists) {
    return []
  }

  ls $dir
  | where type == dir
  | where { |entry| not (($entry.name | path basename) | str starts-with ".") }
  | where { |entry| has-visible-entries $entry.name }
  | get name
}

def sort-key [path: string] {
  $path
  | split row "/"
  | where { |part| $part != "" }
  | reverse
  | each { |part| $part | str downcase }
  | str join "\u{0}"
}

def list-projects [] {
  let projects = (
    visible-subdirs $projects_dir
    | each { |organization| visible-subdirs $organization }
    | flatten
  )

  let documents = if (has-visible-entries $documents_dir) {
    [$documents_dir]
  } else {
    []
  }

  [$projects $documents]
  | flatten
  | each { |path| { path: $path, mtime: ((ls $path | get modified | first)) } }
  | sort-by -r mtime
  | get path
}

def pick-project [] {
  let input = (list-projects | str join (char nl))
  let result = (do { $input | ^vicinae dmenu --no-quick-look --no-section --no-footer --no-metadata } | complete)

  if $result.exit_code != 0 {
    exit $result.exit_code
  }

  $result.stdout | str trim
}

def --wrapped --env main [...command: string] {
  if ($command | is-empty) {
    print "Usage: pick-project <command> [args...]"
    exit 1
  }

  let selection = (pick-project)

  if $selection == "" {
    return
  }

  run-external ...$command $selection
}
