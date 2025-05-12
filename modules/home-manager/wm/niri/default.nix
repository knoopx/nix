{
  defaults,
  pkgs,
  lib,
  nix-colors,
  ...
}: let
  # wallpaper = pkgs.theming.mkSVGPatternWallpaper {
  #   style = pkgs.pattern-monster.zebra;
  #   scale = 4;
  #   colors = with defaults.colorScheme.palette; [
  #     #   base01
  #     base00
  #     base02
  #     base03
  #     base04
  #   ];
  # };
  # https://github.com/NotAShelf/wallpkgs
  wallpaper-src = fetchTarball {
    url = "https://github.com/42willow/wallpapers/releases/download/wallpapers/wallpapers-mocha.zip";
    sha256 = "sha256:10s315bd998r73p6i1bhlihc6hkq81jabkhjf24viz61xbs2898r";
  };
  # wallpaper = "${wallpaper-src}/mocha/images/photography/leaves_with_droplets.jpg";
  # wallpaper = "${wallpaper-src}/mocha/images/photography/trees_mountain_fog_1.jpg";
  # wallpaper = "${wallpaper-src}/mocha/images/photography/mountains.jpg";
  # wallpaper = "${wallpaper-src}/mocha/images/art/kurzgesagt/asteroid_miner_2.png";
  # wallpaper = "${wallpaper-src}/mocha/images/art/kurzgesagt/asteroids.png";
  wallpaper = "${wallpaper-src}/mocha/pixel/art/animated_street_night.gif";

  niri-cycle = pkgs.writeShellScriptBin "niri-cycle" ''
    exec ${pkgs.python3}/bin/python3 ${./scripts/niri-cycle.py} "$@"
  '';
in {
  home.packages = with pkgs; [
    kooha
    libnotify
    niri-cycle
    raise-or-open
  ];

  # https://github.com/emersion/mako/blob/master/doc/mako.5.scd
  services.mako = {
    enable = true;
    settings = {
      actions = true;
      markup = true;
      icons = true;
      layer = "top";
      anchor = "top-right";
      border-size = 0;
      border-radius = 10;
      padding = 10;
      width = 330;
      height = 200;
      default-timeout = 5000;
      max-icon-size = 32;
      text-color = lib.mkForce "#${defaults.colorScheme.palette.base00}";
      background-color = lib.mkForce "#${defaults.colorScheme.palette.base0D}";
    };
  };

  systemd.user.services = {
    wallpaper = {
      Install = {
        WantedBy = ["graphical-session.target"];
      };
      Unit = {
        BindTo = ["niri.service"];
        PartOf = ["graphical-session.target"];
      };
      Service = {
        # ExecStart = "${lib.getExe pkgs.swaybg} -i ${wallpaper}";
        # https://github.com/LGFae/swww
        ExecStart = ''${lib.getExe pkgs.mpvpaper} -o "no-audio --loop --video-zoom=0.17" '*' ${wallpaper}'';

        Restart = "on-failure";
      };
    };
  };

  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl

  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "${lib.getExe pkgs.xwayland-satellite}"
    // spawn-at-startup "${lib.getExe pkgs.mako}"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "ags" "run"
    spawn-at-startup "kitty"

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
        default-column-width { proportion 0.75; }
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
        Mod+Space { spawn "ags" "toggle" "launcher"; }

        Mod+Left { focus-column-left; }
        Alt+Left { focus-column-left; }
        Mod+Right { focus-column-right; }
        Alt+Right { focus-column-right; }

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
        match app-id="^org.gnome.NautilusPreviewer$"
        default-column-width
        open-floating true
    }
    window-rule {
        match app-id="io.missioncenter.MissionCenter"
        default-column-width { fixed ${toString (builtins.elemAt defaults.display.windowSize 0)}; }
        default-window-height { fixed ${toString (builtins.elemAt defaults.display.windowSize 1)}; }
        open-floating true
    }
    window-rule {
        match app-id="^org.gnome.Nautilus$"
        block-out-from "screencast"
    }
    window-rule {
        match app-id="^kitty$"
        match app-id="transmission-gtk"
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
