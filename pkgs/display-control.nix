{ pkgs }:

pkgs.writeShellScriptBin "display-control" ''
  case "$1" in
      power-off-monitors)
          ${pkgs.niri}/bin/niri msg action power-off-monitors
          ;;
      power-on-monitors)
          ${pkgs.niri}/bin/niri msg action power-on-monitors
          ;;
      *)
          echo "Usage: $0 power-off-monitors|power-on-monitors"
          exit 1
          ;;
  esac
''