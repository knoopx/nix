{
  pkgs,
  lib,
  nixosConfig,
  nix-colors,
  ...
}: {
  home.packages = [pkgs.niri pkgs.playerctl pkgs.wireplumber pkgs.xwayland-satellite];
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
                layout "${nixosConfig.defaults.keyMap}"
            }
            repeat-delay 600
            repeat-rate 25
            track-layout "global"
        }

        tablet {
            map-to-output "DSI-1"
        }

        touch {
            map-to-output "DSI-1"
        }

        touchpad {
            tap
            //natural-scroll
            dwt
            click-method "clickfinger"
            accel-speed 0.0
        }
        mouse { accel-speed 0.0; }
        trackpoint { accel-speed 0.0; }
        trackball { accel-speed 0.0; }
        warp-mouse-to-focus
        workspace-auto-back-and-forth
    }

    gestures {
        dnd-edge-view-scroll {
            trigger-width 30
            delay-ms 100
            max-speed 1500
        }

        dnd-edge-workspace-switch {
            trigger-height 50
            delay-ms 100
            max-speed 1500
        }

        hot-corners {
            // off
        }
    }

    output "DP-1" {
        background-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
        scale 2.0
        transform "normal"
    }

    output "DSI-1" {
        background-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
        transform "270"
        scale 1.5
    }

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

    prefer-no-csd

    overview {
        backdrop-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
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
            active-color "#${nixosConfig.defaults.colorScheme.palette.base0D}"
        }
        border { off; }
        insert-hint { color "rgb(${nix-colors.lib-core.conversions.hexToRGBString " " nixosConfig.defaults.colorScheme.palette.base0D} / 50%)"; }

        default-column-width { proportion ${toString nixosConfig.defaults.display.defaultColumnWidthPercent}; }
        preset-column-widths {
            ${lib.concatMapStringsSep "\n            " (width: "proportion ${toString width}") nixosConfig.defaults.display.columnWidthPercentPresets}
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
        MouseForward { toggle-overview; }
        Alt+Down { focus-workspace-down; }
        Alt+Up { focus-workspace-up; }
        Mod+C { center-window; }
        Mod+Down { focus-workspace-down; }
        Mod+F { maximize-column; }
        Mod+J { spawn "firefox"; }
        Mod+K { spawn "code"; }
        Mod+L { spawn "kitty"; }
        Mod+I { consume-or-expel-window-left; }
        Mod+Period { toggle-overview; }
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
        Mod+Space { spawn "vicinae"; }
        Mod+Up { focus-workspace-up; }
        Mod+V { spawn "nautilus"; }
        Mod+P { spawn "kitty" "btop"; }
        Mod+Semicolon { spawn "kitty" "${lib.getExe pkgs.opencode}" "--model" "github-copilot/gpt-4.1"; }
        Mod+W { close-window; }
        Print { screenshot; }
        Shift+Print { screenshot-window; }
        XF86AudioLowerVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioNext { spawn "${lib.getExe pkgs.playerctl}" "next"; }
        XF86AudioPlay { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
        XF86AudioPrev { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
        XF86AudioRaiseVolume { spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioStop { spawn "${lib.getExe pkgs.playerctl}" "pause"; }
        XF86MonBrightnessDown { spawn "${lib.getExe pkgs.brightnessctl}" "set" "5%-"; }
        XF86MonBrightnessUp { spawn "${lib.getExe pkgs.brightnessctl}" "set" "5%+"; }
    }

    switch-events {
        lid-close { spawn "${lib.getExe pkgs.niri}" "msg" "action" "power-off-monitors"; }
        //"loginctl" "lock-session"
        tablet-mode-on { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"; }
        tablet-mode-off { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"; }
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

    layer-rule {
        match namespace="notifications"
        block-out-from "screen-capture"
    }

    animations {
        slowdown 0.6
        window-open { off; }
        window-close { off; }
    }

    window-rule {
        match app-id="scrcpy"
        open-floating false;
        default-column-width { fixed 472; }
        geometry-corner-radius 18.0 18.0 18.0 18.0
    }

    ${lib.concatStringsSep "\n" (
      let
        appWidths = nixosConfig.defaults.display.appWidths or {};
        floatingApps = nixosConfig.defaults.display.floatingApps or [];
        isFloating = appId: lib.elem appId floatingApps;
        rules = lib.map (
          appId: let
            width = appWidths.${appId};
            floating = isFloating appId;
            matchLine = "match app-id=\"${appId}\"";
            widthLine =
              if width != null
              then "default-column-width { proportion ${toString width}; }"
              else null;
            floatingLine =
              if floating
              then "open-floating true"
              else null;
            body = lib.concatStringsSep "\n" (lib.filter (x: x != null) [matchLine widthLine floatingLine]);
          in
            if body != ""
            then "window-rule {\n${body}\n}"
            else null
        ) (lib.attrNames appWidths);
        floatingOnly = lib.filter (appId: !(appWidths ? appId)) floatingApps;
        floatingRules =
          lib.map (
            appId: "window-rule {\nmatch app-id=\"${appId}\"\nopen-floating true\n}"
          )
          floatingOnly;
      in
        rules ++ floatingRules
    )}
  '';
}
