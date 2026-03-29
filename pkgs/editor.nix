{
  pkgs,
  lib,
}: let
  terminal = pkgs.callPackage ./terminal.nix {};
in
  pkgs.runCommand "editor" {
    meta.mainProgram = "editor";
  } ''
    mkdir -p $out/bin

    cat > $out/bin/editor <<'EOF'
    #!${pkgs.runtimeShell}
    set -eu

    terminal_bin="${lib.getExe terminal}"
    helix_bin="${lib.getExe pkgs.helix}"

    if [ "$#" -eq 0 ]; then
      exec "$terminal_bin" "$helix_bin"
    fi

    exec "$terminal_bin" "$helix_bin" -- "$@"
    EOF

    chmod +x $out/bin/editor
  ''
