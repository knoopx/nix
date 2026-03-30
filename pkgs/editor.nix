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

    # Detect if we can run a TUI directly or need to spawn a terminal
    # A TUI needs stdin and stdout to be terminals
    can_run_tui=false
    if [ -t 0 ] && [ -t 1 ]; then
      can_run_tui=true
    fi

    if [ "$can_run_tui" = true ]; then
      # Can run helix directly in the current terminal
      if [ "$#" -eq 0 ]; then
        exec "$helix_bin"
      fi
      exec "$helix_bin" -- "$@"
    else
      # Spawn kitty with helix
      if [ "$#" -eq 0 ]; then
        exec "$terminal_bin" "$helix_bin"
      fi
      exec "$terminal_bin" "$helix_bin" -- "$@"
    fi
    EOF

    chmod +x $out/bin/editor
  ''
