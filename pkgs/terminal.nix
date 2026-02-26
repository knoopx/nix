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

  wezterm_bin="${lib.getExe pkgs.wezterm}"

  if [ "$#" -eq 0 ]; then
    exec "$wezterm_bin" start
  fi

  exec "$wezterm_bin" start -- "$@"
  EOF

  chmod +x $out/bin/terminal
''
