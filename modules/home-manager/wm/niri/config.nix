{
  pkgs,
  nixosConfig,
  nix-colors,
  ...
}: let
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
in {
  services.gnome-keyring.enable = true;
  home.packages = [pkgs.playerctl pkgs.wireplumber pkgs.xwayland-satellite];

  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb.layout = nixosConfig.defaults.keyMap;
          repeat-delay = 600;
          repeat-rate = 25;
          track-layout = "global";
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
          dwt = true;
          click-method = "clickfinger";
          accel-speed = 0.0;
        };

        mouse.accel-speed = 0.0;
        trackpoint.accel-speed = 0.0;
        trackball.accel-speed = 0.0;

        warp-mouse-to-focus.enable = true;
        workspace-auto-back-and-forth = true;
      };

      gestures = {
        hot-corners.enable = false;
      };

      outputs = {
        "LG HDR 4K" = {
          scale = 1.75;
          background-color = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        };

        "GIGA-BYTE TECHNOLOGY CO., LTD. MO27U2 25130B000565" = {
          mode = {
            width = 3840;
            height = 2160;
            refresh = 240.0;
          };
          scale = 1.5;
          background-color = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        };
      };

      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";

      prefer-no-csd = true;

      overview = {
        backdrop-color = "#${nixosConfig.defaults.colorScheme.palette.base02}";
        workspace-shadow.enable = false;
        zoom = 0.7;
      };

      layout = {
        gaps = 12;
        background-color = "transparent";
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
        focus-ring = {
          enable = true;
          width = 3;
          active.color = "#${nixosConfig.defaults.colorScheme.palette.base0D}";
        };
        border = {
          width = 3;
          active.color = "#${nixosConfig.defaults.colorScheme.palette.base03}";
          inactive.color = "#${nixosConfig.defaults.colorScheme.palette.base03}";
        };
        insert-hint.display.color = "rgb(${nix-colors.lib-core.conversions.hexToRGBString " " nixosConfig.defaults.colorScheme.palette.base0D} / 50%)";

        default-column-width.proportion = nixosConfig.defaults.display.defaultColumnWidthPercent;
        preset-column-widths = map (width: {proportion = width;}) nixosConfig.defaults.display.columnWidthPercentPresets;
        center-focused-column = "on-overflow";
        always-center-single-column = true;
      };

      cursor = {
        theme = "default";
        size = 24;
        hide-when-typing = true;
      };

      hotkey-overlay.skip-at-startup = true;

      xwayland-satellite = {
        enable = true;
        path = "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite";
      };

      environment = {
        GIO_EXTRA_MODULES = "${nixosConfig.services.gvfs.package}/lib/gio/modules";
      };

      binds = {
        "MouseForward".action = {toggle-overview = [];};
        "Alt+Down".action = {"focus-workspace-down" = [];};
        "Alt+Up".action = {"focus-workspace-up" = [];};
        "Mod+C".action = {"center-window" = [];};
        "Mod+Down".action = {"focus-workspace-down" = [];};
        "Mod+F".action = {"maximize-column" = [];};
        "Mod+J".action = {spawn = "firefox";};
        "Mod+K".action = {spawn = "code";};
        "Mod+L".action = {spawn = "kitty";};
        "Mod+I".action = {"consume-or-expel-window-left" = [];};
        "Mod+Period".action = {"toggle-overview" = [];};
        "Mod+Left".action = {"focus-column-left" = [];};
        "Mod+O".action = {"consume-or-expel-window-right" = [];};
        "Mod+Q".action = {"close-window" = [];};
        "Mod+R".action = {"switch-preset-column-width" = [];};
        "Mod+Tab".action = {"switch-focus-between-floating-and-tiling" = [];};
        "Mod+Return".action = {spawn = "${toggle-float-script}";};
        "Mod+Right".action = {"focus-column-right" = [];};
        "Mod+Shift+Ctrl+L".action = {quit = {"skip-confirmation" = true;};};
        "Mod+Shift+Down".action = {"move-column-to-workspace-down" = [];};
        "Mod+Shift+End".action = {"move-workspace-down" = [];};
        "Mod+Shift+F".action = {"fullscreen-window" = [];};
        "Mod+Shift+Home".action = {"move-workspace-up" = [];};
        "Mod+Shift+Left".action = {"move-column-left" = [];};
        "Mod+Shift+Right".action = {"move-column-right" = [];};
        "Mod+Shift+Up".action = {"move-column-to-workspace-up" = [];};
        "Mod+Space".action = {spawn = ["vicinae" "toggle"];};
        "Mod+Up".action = {"focus-workspace-up" = [];};
        "Mod+V".action = {spawn = "nautilus";};
        "Mod+P".action = {spawn = ["kitty" "btop"];};
        "Mod+W".action = {"close-window" = [];};
        "Print".action = {screenshot = [];};
        "Shift+Print".action = {"screenshot-window" = [];};
        "XF86AudioLowerVolume".action = {spawn = ["volume-control" "down"];};
        "XF86AudioMute".action = {spawn = ["volume-control" "mute"];};
        "XF86AudioNext".action = {spawn = ["media-control" "next"];};
        "XF86AudioPlay".action = {spawn = ["media-control" "play-pause"];};
        "XF86AudioPrev".action = {spawn = ["media-control" "previous"];};
        "XF86AudioRaiseVolume".action = {spawn = ["volume-control" "up"];};
        "XF86AudioStop".action = {spawn = ["media-control" "stop"];};
        "XF86MonBrightnessDown".action = {spawn = ["brightness-control" "down"];};
        "XF86MonBrightnessUp".action = {spawn = ["brightness-control" "up"];};
      };

      switch-events = {
        lid-close.action = {spawn = ["display-control" "power-off-monitors"];};
        tablet-mode-on.action = {spawn = ["bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true"];};
        tablet-mode-off.action = {spawn = ["bash" "-c" "gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false"];};
      };

       window-rules = nixosConfig.defaults.display.windowRules;
       layer-rules = nixosConfig.defaults.display.layerRules;

      animations = {
        slowdown = 0.6;
        window-open.enable = false;
        window-close.enable = false;
      };
    };
  };
}
