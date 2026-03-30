#!/usr/bin/env nu

let documents_dir = ($env.HOME | path join "Documents")

def list-documents [] {
  ^find $documents_dir -iname "*.md"
  | str trim
  | split row (char nl)
  | where $it != ""
  | each {|path|
    let content = (open --raw $path)
    let raw_title = ($content | split row "\n" | where {|x| $x =~ "^# "} | get 0?)
    let title = (if $raw_title != null { $raw_title | str substring 2.. } else { "" })
    {
      title: (if $title == "" { $path | path basename } else { $title })
      path: $path
      mtime: ((ls $path | get modified | first))
    }
  }
  | sort-by -r mtime
  | each {|it| $it.path + "/" + $it.title}
  | str join "\n"
}

def pick-document [] {
  let input = list-documents
  let result = (do { $input | ^vicinae dmenu --no-quick-look --no-section --no-footer --no-metadata } | complete)

  if $result.exit_code != 0 {
    exit $result.exit_code
  }

  $result.stdout | str trim                         
  let selection = $result.stdout | str trim         
  $selection | split row "/" | drop 1 | str join "/"
}

def --wrapped --env main [...command: string] {
  if ($command | is-empty) {
    print "Usage: pick-document <command> [args...]"
    exit 1
  }

  let selection = (pick-document)

  if $selection == "" {
    return
  }

  run-external ...$command ...[$selection]
}
