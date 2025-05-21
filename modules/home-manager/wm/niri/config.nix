{
  pkgs,
  lib,
  defaults,
  nix-colors,
  ...
}: let
  niri-cycle = pkgs.writeShellScriptBin "niri-cycle" ''
    exec ${pkgs.python3}/bin/python3 ${./scripts/niri-cycle.py} "$@"
  '';
in {
  home.packages = with pkgs; [
    niri-cycle
  ];

  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl

  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "${lib.getExe pkgs.xwayland-satellite}"
    spawn-at-startup "ags" "run"

    input {
        keyboard {
            xkb {
                layout "eu"
                model ""
                rules ""
                variant ""
            }
            repeat-delay 600
            repeat-rate 25
            track-layout "global"
        }
        touchpad {
            tap
            natural-scroll
            accel-speed 0.00
        }
        mouse { accel-speed 0.0; }
        trackpoint { accel-speed 0.0; }
        trackball { accel-speed 0.0; }
        tablet
        touch
        warp-mouse-to-focus
        workspace-auto-back-and-forth
    }
    output "DP-1" {
        scale 2.00
        transform "normal"
    }
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    prefer-no-csd

    layout {
        gaps 16
        struts {
            left 0
            right 0
            top 0
            bottom 0
        }
        focus-ring {
            width 3
            active-color "#${defaults.colorScheme.palette.base0D}"
            inactive-color "#${defaults.colorScheme.palette.base02}"
        }
        border {
            width 1
            active-color "#${defaults.colorScheme.palette.base02}"
            inactive-color "#${defaults.colorScheme.palette.base02}"
        }
        shadow {
            on
            offset x=0.00 y=5.00
            softness 30.00
            spread 5.00
            draw-behind-window false
            color "#000"
        }
        insert-hint { color "rgb(${nix-colors.lib-core.conversions.hexToRGBString " " defaults.colorScheme.palette.base0D} / 50%)"; }
        //default-column-width { proportion 0.75; }
        default-column-width { fixed ${toString (builtins.elemAt defaults.display.windowSize 0)}; }
        preset-column-widths {
            proportion 0.25
            proportion 0.50
            proportion 0.75
        }
        center-focused-column "on-overflow"
        always-center-single-column
    }

    cursor {
        xcursor-theme "default"
        xcursor-size 24
        hide-when-typing
    }

    gestures {
        // hot-corners { off }
    }

    hotkey-overlay { skip-at-startup; }

    overview {
      zoom 0.7
      backdrop-color "#${defaults.colorScheme.palette.base02}"
    }

    environment {
        DISPLAY ":0"
    }

    binds {
        Mod+G { spawn "firefox"; }
        Mod+B { spawn "code"; }
        Mod+T { spawn "kitty"; }
        Mod+V { spawn "nautilus"; }
        Mod+Delete { spawn "${lib.getExe pkgs.mission-center}"; }
        //Mod+D { spawn "ags" "toggle" "launcher"; }
        //Super+Super_L { spawn "ags" "toggle" "launcher"; }
        //Mod+Space { spawn "ags" "toggle" "launcher"; }
        Mod+Space { spawn "${lib.getExe pkgs.launcher}"; }

        Mod+Left { focus-column-left; }
        //Alt+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        //Alt+Right { focus-column-right; }

        //Mod+WheelScrollUp   cooldown-ms=150 { focus-column-left; }
        //Mod+WheelScrollDown cooldown-ms=150 { focus-column-right; }
        //Mod+MouseMiddle { close-window; }
        //Mod+MouseRight   { toggle-overview; }

        Mod+W { close-window; }
        Mod+Q { close-window; }
        Mod+C { center-window; }
        Mod+F { maximize-column; }
        Mod+R { switch-preset-column-width; }
        Mod+Return { toggle-window-floating; }
        Mod+Shift+F { fullscreen-window; }
        Mod+I { consume-or-expel-window-left; }
        Mod+O { consume-or-expel-window-right; }

        Mod+Shift+Down { move-column-to-workspace-down; }
        Mod+Shift+End { move-workspace-down; }
        Mod+Shift+Home { move-workspace-up; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-column-to-workspace-up; }

        Mod+Up { focus-workspace-up; }
        Alt+Up { focus-workspace-up; }

        Mod+Down { focus-workspace-down; }
        Alt+Down { focus-workspace-down; }

        Mod+J { toggle-overview; }

        Mod+Shift+Ctrl+L { quit skip-confirmation=true; }

        Print { screenshot; }
        Shift+Print { screenshot-window; }

        Mod+Tab { spawn "${lib.getExe niri-cycle}"; }
        Shift+Mod+Tab { spawn "${lib.getExe niri-cycle}" "--reverse"; }
        Mod+Escape { spawn "${lib.getExe niri-cycle}" "--app"; }
        Shift+Mod+Escape { spawn "${lib.getExe niri-cycle}" "--app" "--reverse"; }

        XF86AudioPlay { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
        XF86AudioStop { spawn "${lib.getExe pkgs.playerctl}" "pause"; }
        XF86AudioNext { spawn "${lib.getExe pkgs.playerctl}" "next"; }
        XF86AudioPrev { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
        XF86AudioRaiseVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
    }

    // https://github.com/YaLTeR/niri/blob/main/wiki/Configuration:-Window-Rules.md

    window-rule {
        draw-border-with-background false
        geometry-corner-radius 8.0 8.0 8.0 8.0
        clip-to-geometry true
    }
    window-rule {
        match is-active=false
        opacity 0.90
    }

    window-rule {
        match app-id="org.gnome.NautilusPreviewer"
        match app-id="re.sonny.Commit"
        match app-id="^floating."
        open-floating true
    }
    window-rule {
        match app-id="io.missioncenter.MissionCenter"
        default-column-width { fixed ${toString (builtins.elemAt defaults.display.windowSize 0)}; }
        default-window-height { fixed ${toString (builtins.elemAt defaults.display.windowSize 1)}; }
        open-floating true
    }
    window-rule {
        match app-id="net.knoopx.nix-packages"
        match app-id="net.knoopx.launcher"
        open-floating true
    }
    window-rule {
        match app-id="^org.gnome.Nautilus$"
        block-out-from "screencast"
    }
    window-rule {
        match app-id="kitty"
        match app-id="transmission-gtk"
        match app-id="net.knoopx.chat"
        default-column-width { proportion 0.5; }
    }
    window-rule {
        match app-id="Plexamp"
        default-column-width { proportion 0.25; }
    }
    window-rule {
        match app-id="org.gnome.Calendar"
        match app-id="org.gnome.Weather"
        //match app-id="com.github.qarmin.czkawka"
        default-column-width { proportion 0.75; }
        open-floating true
    }
    layer-rule {
        match namespace="notifications"
        block-out-from "screen-capture"
    }

    animations { slowdown 0.6; }
  '';
}
