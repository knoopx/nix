#!/usr/bin/env bash
set -Eeu

root="$(readlink --canonicalize -- "$(dirname -- "$0")")"

trap 'rm -f "$root/default.nix"' EXIT
cat >"$root/default.nix" <<NIX
_: import <nixpkgs> { overlays = [ (self: super: import ./pkgs/default.nix { pkgs = super; }) ]; }
NIX

nixpkgs="$(nix-instantiate --eval --expr '<nixpkgs>')"

nix-shell "$nixpkgs/maintainers/scripts/update.nix" --arg include-overlays "(import $root { }).overlays" --arg predicate "(
    let prefix = \"$root/pkgs/\"; prefixLen = builtins.stringLength prefix;
    in (path: pkg: (builtins.hasAttr \"position\" pkg.meta) && ((builtins.substring 0 prefixLen pkg.meta.position) == prefix))
  )" --arg keep-going 'true'

if [[ -f "$root/update-git-commits.txt" ]]; then
  cat "$root/update-git-commits.txt" && rm "$root/update-git-commits.txt"
fi
