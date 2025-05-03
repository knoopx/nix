{
  defaults,
  pkgs,
  lib,
  ...
}: let
  wallpaper = pkgs.theming.mkSVGPatternWallpaper {
    style = pkgs.pattern-monster.doodle-1;
    scale = 4;
    colors = with defaults.colorScheme.palette; [
      #   base01
      #   base00
      base02
      base03
      base04
    ];
  };
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
    layer = "top";
    anchor = "top-right";
    borderSize = 0;
    borderRadius = 10;
    padding = "10";
    width = 330;
    height = 200;
    defaultTimeout = 5000;
    maxIconSize = 32;
    textColor = lib.mkForce "#${defaults.colorScheme.palette.base00}";
    backgroundColor = lib.mkForce "#${defaults.colorScheme.palette.base0D}";
  };

  # services.swayosd.enable = true;

  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl

  xdg.configFile."niri/config.kdl".text = ''
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
            active-color "fad000"
            inactive-color "313244"
        }
        border {
            width 1
            active-color "#313244"
            inactive-color "#313244"
        }
        shadow {
            on
            offset x=0.00 y=5.00
            softness 30.00
            spread 5.00
            draw-behind-window false
            color "#0070"
        }
        insert-hint { color "rgb(127 200 255 / 50%)"; }
        default-column-width { proportion 0.75; }
        preset-column-widths {
            proportion 0.25
            proportion 0.50
            proportion 0.75
        }
        center-focused-column "never"
        always-center-single-column
    }

    cursor {
        xcursor-theme "default"
        xcursor-size 24
        hide-when-typing
    }

    hotkey-overlay { skip-at-startup; }

    overview {
      zoom 0.75
      backdrop-color "#${defaults.colorScheme.palette.base02}"
    }

    environment {
        DISPLAY ":0"
        "GBM_BACKEND" "nvidia-drm"
        "GDK_BACKEND" "wayland"
        "LIBVA_DRIVER_NAME" "nvidia"
        "MOZ_ENABLE_WAYLAND" "1"
        "NVD_BACKEND" "direct"
        "NVIDIA_DRIVER_CAPABILITIES" "all"
        "NVIDIA_VISIBLE_DEVICES" "all"
        "QT_QPA_PLATFORM" "wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"
        "SDL_VIDEODRIVER" "wayland"
        "WLR_BACKEND" "vulkan"
        "WLR_DRM_NO_ATOMIC" "1"
        "WLR_NO_HARDWARE_CURSORS" "1"
        "WLR_RENDERER" "vulkan"
        "XDG_SESSION_TYPE" "wayland"
        "_EGL_VENDOR_LIBRARY_FILENAMES" "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json"
        "__GLX_VENDOR_LIBRARY_NAME" "nvidia"
    }

    binds {
        Mod+G { spawn "firefox"; }
        Mod+B { spawn "code"; }
        Mod+T { spawn "kitty"; }
        Mod+Delete { spawn "${lib.getExe pkgs.mission-center}"; }
        //Mod+D { spawn "ags" "toggle" "launcher"; }
        Mod+Space { spawn "ags" "toggle" "launcher"; }

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

        Alt+Down { focus-workspace-down; }
        Alt+Left { focus-column-left; }
        Alt+Right { focus-column-right; }
        Alt+Up { focus-workspace-up; }
        Mod+C { center-window; }
        Mod+Down { focus-workspace-down; }
        Mod+F { maximize-column; }
        Mod+I { consume-or-expel-window-left; }
        Mod+Left { focus-column-left; }
        Mod+O { consume-or-expel-window-right; }
        Mod+Q { close-window; }
        Mod+R { switch-preset-column-width; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Ctrl+L { spawn "niri" "msg" "action" "quit" "-s"; }
        Mod+Shift+Down { move-column-to-workspace-down; }
        Mod+Shift+End { move-workspace-down; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+Home { move-workspace-up; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-column-to-workspace-up; }
        Mod+Slash { show-hotkey-overlay; }
        // Mod+Space { toggle-window-floating; }

        Mod+Up { focus-workspace-up; }
        Mod+W { close-window; }
        Print { screenshot; }
        Shift+Print { screenshot-window; }
        Super+J { toggle-overview; }
    }

    spawn-at-startup "${lib.getExe pkgs.xwayland-satellite}"
    spawn-at-startup "${lib.getExe pkgs.mako}"
    spawn-at-startup "${lib.getExe pkgs.swaybg}" "--image" "${wallpaper.outPath}"
    spawn-at-startup "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    spawn-at-startup "ags" "run"

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
        default-column-width { fixed 1240; }
        default-window-height { fixed 900; }
        open-floating true
    }
    window-rule {
        match app-id="^org.gnome.Nautilus$"
        block-out-from "screencast"
    }
    window-rule {
        match app-id="^kitty$"
        default-column-width { proportion 0.5; }
    }
    window-rule {
        match app-id="Plexamp"
        default-column-width { proportion 0.25; }
    }
    window-rule {
        match app-id="org.gnome.Calendar"
        match app-id="org.gnome.Weather"
        match app-id="com.github.qarmin.czkawka"
        default-column-width { proportion 0.75; }
        open-floating true
    }
    layer-rule {
        match namespace="notifications"
        block-out-from "screen-capture"
    }
    animations { slowdown 1.0; }
  '';
}
