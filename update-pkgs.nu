#!/usr/bin/env nu

let root = "/home/knoopx/.nix"
let overlay_path = ($root | path join "overlay.nix")
let git_commits_file = ($root | path join "update-git-commits.txt")
let pkgs_prefix = ($root | path join "pkgs")

let cleanup = { rm -f $overlay_path }
try {
    cat $overlay_path | save -f $overlay_path

    let nixpkgs = (nix-instantiate --eval --expr '<nixpkgs>')
    let update_script = ($nixpkgs | path join "maintainers/scripts/update.nix")

    let predicate = $"""(path: pkg:
        (builtins.hasAttr "position" pkg.meta)
        and ((builtins.substring 0 (builtins.stringLength "` + $pkgs_prefix + `") pkg.meta.position) == "` + $pkgs_prefix + `")
    )"""

    nix-shell $update_script --arg include-overlays $"[ (import ($overlay_path)) ]" --arg predicate $predicate --arg keep-going 'true'

    if ($git_commits_file | path exists) {
        cat $git_commits_file
        rm $git_commits_file
    }
} catch { $cleanup }

ignore
