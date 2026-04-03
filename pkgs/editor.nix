{
  pkgs,
  lib,
}: let
  terminal = pkgs.terminal;
in
  pkgs.runCommand "editor" {
    meta.mainProgram = "editor";
  } ''
    mkdir -p $out/bin

    cat > $out/bin/editor <<'EOF'
    #!${pkgs.runtimeShell}
    set -eu
    exec "${lib.getExe pkgs.gram}" "$@"
    EOF

    chmod +x $out/bin/editor
  ''
