{ pkgs }:

pkgs.writeShellScriptBin "session-control" ''
  case "$1" in
      lock)
          ${pkgs.hyprlock}/bin/hyprlock
          ;;
      logout)
           ${pkgs.niri}/bin/niri msg action quit
          ;;
      suspend)
          systemctl suspend
          ;;
      hibernate)
          systemctl hibernate
          ;;
      reboot)
          systemctl reboot
          ;;
      poweroff)
          systemctl poweroff
          ;;
      *)
          echo "Usage: $0 lock|logout|suspend|hibernate|reboot|poweroff"
          exit 1
          ;;
  esac
''