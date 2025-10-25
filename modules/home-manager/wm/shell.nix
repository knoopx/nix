{pkgs, ...}: let
  # Volume control script with audio feedback
  volumeScript = pkgs.writeShellScriptBin "volume-control" ''
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
  '';

  # Brightness control script
  brightnessScript = pkgs.writeShellScriptBin "brightness-control" ''
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
  '';

  # Media control script
  mediaScript = pkgs.writeShellScriptBin "media-control" ''
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
  '';

  # Display control script
  displayScript = pkgs.writeShellScriptBin "display-control" ''
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
  '';

   # Session control script
   sessionScript = pkgs.writeShellScriptBin "session-control" ''
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
   '';
in {
  home.packages = [
    volumeScript
    brightnessScript
    mediaScript
    displayScript
    sessionScript
  ];
}
