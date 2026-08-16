#!/usr/bin/env nu

let skills_dir = ("~/.pi/agent/skills" | path expand)

def list-agents [] {
  ^find $skills_dir -path "*/agents/*.md"
  | split row (char nl)
  | each { |f| { name: ($f | path basename | str replace --all ".md" ""), path: $f } }
  | sort-by name
}

def pick-agent [] {
  let agents = (list-agents)
  if ($agents | length) == 0 {
    print "No agents found"
    exit 1
  }

  let input = ($agents | get name | str join (char nl))
  let result = (do { $input | ^vicinae dmenu --no-quick-look --no-section --no-footer --no-metadata --navigation-title 'Pi Agent' --placeholder 'Select agent...' } | complete)

  if $result.exit_code != 0 {
    exit $result.exit_code
  }

  let selected = ($result.stdout | str trim)
  $agents | where name == $selected | get 0
}

def --wrapped main [...rest: string] {
  let selection = (pick-agent)
  if $selection == null { return }

  let content = (($selection | get path) | open --raw)
  ^terminal pi --system-prompt $content
}