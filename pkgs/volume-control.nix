{ pkgs }:

pkgs.writeShellScriptBin "volume-control" ''
  case "$1" in
      up)
          ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
          ;;
      down)
          ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
          ;;
      mute)
          ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
          ;;
      *)
          echo "Usage: $0 up|down|mute"
          exit 1
          ;;
  esac

  ${pkgs.pipewire}/bin/pw-play ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
''