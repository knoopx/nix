{
  pkgs,
  nixosConfig,
  lib,
  defaults,
  nix-colors,
  ...
}: {
  home.packages = [pkgs.niri];
  services.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };

  # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            xkb {
                layout "eu"
            }
            repeat-delay 600
            repeat-rate 25
            track-layout "global"
        }
        touchpad {
            tap
            natural-scroll
            accel-speed 0.0
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
        background-color "#${defaults.colorScheme.palette.base02}"
        scale 2.0
        transform "normal"
    }

    output "DSI-1" {
        background-color "#${defaults.colorScheme.palette.base02}"
        transform "270"
        scale 1.5
    }

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

    prefer-no-csd

    overview {
        backdrop-color "#${defaults.colorScheme.palette.base02}"
        workspace-shadow {
            off
            softness 40.0
            spread 10.0
            color "#00000050"
        }
        zoom 0.700000
    }

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
        }
        border { off; }
        insert-hint { color "rgb(${nix-colors.lib-core.conversions.hexToRGBString " " defaults.colorScheme.palette.base0D} / 50%)"; }

        default-column-width { proportion 0.75; }
        preset-column-widths {
            proportion 0.25
            proportion 0.5
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

    hotkey-overlay { skip-at-startup; }

    xwayland-satellite {
        path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
    }

    environment {
        // required for nautilus to launch properly (because niri spawn does not set env)
        GIO_EXTRA_MODULES "${nixosConfig.services.gvfs.package}/lib/gio/modules"
    }

    binds {
        Alt+Down { focus-workspace-down; }
        Alt+Up { focus-workspace-up; }
        Mod+C { center-window; }
        Mod+Delete { spawn "${lib.getExe pkgs.mission-center}"; }
        Mod+Down { focus-workspace-down; }
        Mod+F { maximize-column; }
        Mod+G { spawn "code"; }
        Mod+H { spawn "firefox"; }
        Mod+I { consume-or-expel-window-left; }
        Mod+J { toggle-overview; }
        Mod+Left { focus-column-left; }
        Mod+O { consume-or-expel-window-right; }
        Mod+Q { close-window; }
        Mod+R { switch-preset-column-width; }
        Mod+Return { toggle-window-floating; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Ctrl+L { quit skip-confirmation=true; }
        Mod+Shift+Down { move-column-to-workspace-down; }
        Mod+Shift+End { move-workspace-down; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+Home { move-workspace-up; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-column-to-workspace-up; }
        Mod+Space { spawn "${lib.getExe pkgs.launcher}"; }
        Mod+T { spawn "kitty"; }
        Mod+Up { focus-workspace-up; }
        Mod+V { spawn "nautilus"; }
        Mod+W { close-window; }
        Print { screenshot; }
        Shift+Print { screenshot-window; }
        XF86AudioLowerVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioNext { spawn "${lib.getExe pkgs.playerctl}" "next"; }
        XF86AudioPlay { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
        XF86AudioPrev { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
        XF86AudioRaiseVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioStop { spawn "${lib.getExe pkgs.playerctl}" "pause"; }
    }
    window-rule {
        match
        draw-border-with-background false
        geometry-corner-radius 8.0 8.0 8.0 8.0
        clip-to-geometry true
    }
    window-rule {
        match is-active=false
        opacity 0.9
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
        match app-id="net.knoopx.launcher"
        match app-id="net.knoopx.nix-packages"
        match app-id="net.knoopx.bookmarks"
        match app-id="net.knoopx.scratchpad"
        match app-id="net.knoopx.windows"
        match app-id="net.knoopx.process-manager"
        default-column-width { proportion 0.25; }
        open-floating true
    }
    window-rule {
        match app-id="org.gnome.Nautilus"
        block-out-from "screencast"
    }
    window-rule {
        match app-id="code"
        default-column-width { proportion 1.0; }
    }
    window-rule {
        match app-id="net.knoopx.notes"
        default-column-width { proportion 0.75; }
    }
    window-rule {
        match app-id="kitty"
        match app-id="transmission-gtk"
        match app-id="net.knoopx.chat"
        default-column-width { proportion 0.5; }
    }
    window-rule {
        match app-id="net.knoopx.music"
        default-column-width { proportion 0.33; }
    }
    window-rule {
        match app-id="Plexamp"
        match app-id="io.bassi.Amberol"
        default-column-width { proportion 0.25; }
    }
    window-rule {
        match app-id="org.gnome.Calendar"
        match app-id="org.gnome.Weather"
        default-column-width { proportion 0.75; }
        open-floating true
    }
    layer-rule {
        match namespace="notifications"
        block-out-from "screen-capture"
    }

    animations {
        slowdown 0.6
        window-open { off; }
        window-close { off; }
    }
  '';
}
