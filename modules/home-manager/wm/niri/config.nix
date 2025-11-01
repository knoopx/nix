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

  xdg.configFile."niri/config.kdl".text = let
    toggle-float-script = pkgs.writeShellScript "toggle-float" ''
      window_width=800
      window_height=600
      margin=15

      is_floating=$(niri msg --json windows | jq -r '.[] | select(.is_focused == true) | .is_floating')

      if [ "$is_floating" = "true" ]; then
        niri msg action toggle-window-floating
        niri msg action set-column-width ${toString (nixosConfig.defaults.display.defaultColumnWidthPercent * 100)}%
        niri msg action reset-window-height
      else
        focused_output=$(niri msg --json workspaces | jq -r '.[] | select(.is_focused == true) | .output')
        scale=$(niri msg --json outputs | jq -r ".[\"$focused_output\"].logical.scale")
        width=$(niri msg --json outputs | jq -r ".[\"$focused_output\"].logical.width")
        height=$(niri msg --json outputs | jq -r ".[\"$focused_output\"].logical.height")

        x=$((width - window_width - margin))
        y=$((height - window_height - margin))

        niri msg action toggle-window-floating
        niri msg action set-window-width $window_width
        niri msg action set-window-height $window_height
        niri msg action move-floating-window --x $x --y $y
      fi
    '';
  in ''
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
            off
        }
    }


    output "DSI-1" {
        background-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
        transform "270"
        scale 1.5
    }


    output "LG HDR 4K" {
        background-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
        scale 1.75
    }

    output "Virtual-1" {
        background-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
        scale 1.5
    }

    screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

    prefer-no-csd

    overview {
        backdrop-color "#${nixosConfig.defaults.colorScheme.palette.base02}"
        workspace-shadow {
            off
        }
        zoom 0.700000
    }

    layout {
        gaps 12
        background-color "transparent"
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
        border {
            width 3
            active-color "#${nixosConfig.defaults.colorScheme.palette.base03}"
            inactive-color "#${nixosConfig.defaults.colorScheme.palette.base03}"
        }
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
        Mod+Tab { switch-focus-between-floating-and-tiling; }
        Mod+Return { spawn "${toggle-float-script}"; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Ctrl+L { quit skip-confirmation=true; }
        Mod+Shift+Down { move-column-to-workspace-down; }
        Mod+Shift+End { move-workspace-down; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Shift+Home { move-workspace-up; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+Up { move-column-to-workspace-up; }
        Mod+Space { spawn "vicinae" "toggle"; }
        Mod+Up { focus-workspace-up; }
        Mod+V { spawn "nautilus"; }
        Mod+P { spawn "kitty" "btop"; }
        Mod+W { close-window; }
        Print { screenshot; }
        Shift+Print { screenshot-window; }
        XF86AudioLowerVolume { spawn "volume-control" "down"; }
        XF86AudioMute { spawn "volume-control" "mute"; }
        XF86AudioNext { spawn "media-control" "next"; }
        XF86AudioPlay { spawn "media-control" "play-pause"; }
        XF86AudioPrev { spawn "media-control" "previous"; }
        XF86AudioRaiseVolume { spawn "volume-control" "up"; }
        XF86AudioStop { spawn "media-control" "stop"; }
        XF86MonBrightnessDown { spawn "brightness-control" "down"; }
        XF86MonBrightnessUp { spawn "brightness-control" "up"; }
    }

    switch-events {
        lid-close { spawn "display-control" "power-off-monitors"; }
        //"loginctl" "lock-session"
        tablet-mode-on { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"; }
        tablet-mode-off { spawn "bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"; }
    }

    window-rule {
        draw-border-with-background false
        geometry-corner-radius 8.0 8.0 8.0 8.0
        clip-to-geometry true
    }


    window-rule {
        match is-floating=true
        geometry-corner-radius 16.0 16.0 16.0 16.0
    }

    window-rule {
        match app-id="scrcpy"
        open-floating false;
        default-column-width { fixed 472; }
        geometry-corner-radius 18.0 18.0 18.0 18.0
    }


    window-rule {
        match app-id="org.gnome.NautilusPreviewer"
        open-floating true;
        default-column-width { proportion 0.75; }
        default-window-height { proportion 0.75; }
    }

    window-rule {
        match is-active=false
        opacity 0.9
    }

    window-rule {
        match is-floating=true
        opacity 1.0
    }

    layer-rule {
        match namespace="notifications"
        block-out-from "screen-capture"
    }

    layer-rule {
        // This is for swaybg; change for other wallpaper tools.
        // Find the right namespace by running niri msg layers.
        match namespace="^wallpaper$"
        place-within-backdrop true
    }

    animations {
        slowdown 0.6
        window-open { off; }
        window-close { off; }
    }
  '';
}
