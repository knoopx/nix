{
  pkgs,
  lib,
}:
pkgs.runCommand "terminal" {
  meta.mainProgram = "terminal";
} ''
  mkdir -p $out/bin

  cat > $out/bin/terminal <<'EOF'
  #!${pkgs.runtimeShell}
  set -eu

  kitty_bin="${lib.getExe pkgs.kitty}"

  if [ "$#" -eq 0 ]; then
    exec "$kitty_bin"
  fi

  exec "$kitty_bin" -- "$@"
  EOF

  chmod +x $out/bin/terminal
''
