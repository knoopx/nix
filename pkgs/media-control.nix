{ pkgs }:

pkgs.writeShellScriptBin "media-control" ''
  case "$1" in
      play-pause)
          ${pkgs.playerctl}/bin/playerctl play-pause
          ;;
      next)
          ${pkgs.playerctl}/bin/playerctl next
          ;;
      previous)
          ${pkgs.playerctl}/bin/playerctl previous
          ;;
      stop)
          ${pkgs.playerctl}/bin/playerctl pause
          ;;
      *)
          echo "Usage: $0 play-pause|next|previous|stop"
          exit 1
          ;;
  esac
''