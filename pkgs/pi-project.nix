{
  pkgs,
  lib,
}:
pkgs.runCommand "pi-project" {
  meta.mainProgram = "pi-project";
} ''
  mkdir -p $out/bin

  cat > $out/bin/pi-project <<'EOF'
  #!${pkgs.runtimeShell}
  set -eu
  ${lib.getExe pkgs.pick-project} echo | xargs -r sh -c 'cd "$1" && ${lib.getExe pkgs.terminal} pi' --
  EOF

  chmod +x $out/bin/pi-project
''
