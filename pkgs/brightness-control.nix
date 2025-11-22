{ pkgs }:

pkgs.writeShellScriptBin "brightness-control" ''
  case "$1" in
      up)
          ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
          ;;
      down)
          ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
          ;;
      *)
          echo "Usage: $0 up|down"
          exit 1
          ;;
  esac
  ${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
''