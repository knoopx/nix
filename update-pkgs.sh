#!/usr/bin/env bash
set -Eeu

root="$(readlink --canonicalize -- "$(dirname -- "$0")")"

# Mock nixpkgs
trap 'rm -f "$root/default.nix"' EXIT
cat >"$root/default.nix" <<NIX
{}: import <nixpkgs> { overlays = [ (self: super: import ./pkgs/default.nix { pkgs = super; }) ]; }
NIX

nixpkgs="$(nix-instantiate --eval --expr '<nixpkgs>')"
# nix-shell "$nixpkgs/maintainers/scripts/update.nix" --arg include-overlays "(import $root { }).overlays" --arg predicate "(
#     let prefix = \"$root/pkgs/\"; prefixLen = builtins.stringLength prefix;
#     in (_: p: (builtins.substring 0 prefixLen p.meta.position) == prefix)
#   )" --arg keep-going 'true'
nix-shell "$nixpkgs/maintainers/scripts/update.nix" --arg include-overlays "(import $root { }).overlays" --arg predicate "(
    let prefix = \"$root/pkgs/\"; prefixLen = builtins.stringLength prefix;
    in (path: pkg: (builtins.hasAttr \"position\" pkg.meta) && ((builtins.substring 0 prefixLen pkg.meta.position) == prefix))
  )" --arg keep-going 'true'

# Clean up
if [[ -f "$root/update-git-commits.txt" ]]; then
  cat "$root/update-git-commits.txt" && rm "$root/update-git-commits.txt"
fi
