#!/usr/bin/env nu

let skills_root = $nu.home-dir | path join ".pi" "agent" "skills"

# Parse the YAML frontmatter of one agent .md file into a candidate record,
# or null when the file has no frontmatter block or its YAML does not parse.
def parse-agent [file: string] {
    try {
        let raw = open --raw $file | lines
        let first = $raw | get 0? | default ""
        if ($first | str trim) != "---" {
            null
        } else {
            let yaml = (
                $raw
                | skip 1
                | take while {|l| $l != "---" }
                | str join "\n"
                | str trim
            )
            let meta = $yaml | from yaml
            {
                name: ($meta | get name? | default "")
                description: ($meta | get description? | default "")
                type: ($meta | get type? | default "")
                path: $file
            }
        }
    } catch { null }
}

# Candidate source: every .md under the domains' agents/ trees whose
# frontmatter declares `type: agent` — the same source ~/.pi's agent-query uses.
# name/description are read from the frontmatter, not from directory names.
def load-agents [] {
    glob $"($skills_root)/*/agents/**/*.md"
    | where {|f|
        let p = $f | str lowercase
        not (($p | str contains "node_modules") or ($p | str contains "/assets/") or ($p | str contains "__pycache__"))
    }
    | each {|f| (parse-agent $f)}
    | where $in != null
    | where {|r| ($r | get type? | default "") == "agent"}
}

# Interactive selection: pick an agent with vicinae dmenu, one name per line.
def pick-agent [agents: list<any>] {
    let input = $agents | get name | str join (char nl)
    let result = (
        do {
            $input
            | ^vicinae dmenu --no-quick-look --no-section --no-footer --no-metadata --navigation-title 'Pi Agent' --placeholder 'Select agent...'
        }
        | complete
    )

    if $result.exit_code != 0 {
        exit $result.exit_code
    }

    let selected = $result.stdout | str trim
    $agents | where name == $selected | get 0
}

def --wrapped main [...args: string] {
    let agents = (load-agents)
    if ($agents | length) == 0 {
        print "No agents found"
        exit 1
    }

    # Selection is always interactive: the user picks an agent from the picker.
    let selection = (pick-agent $agents)
    if $selection == null {
        return
    }

    let content = ($selection | get path) | open --raw
    ^terminal pi --system-prompt $content
}
