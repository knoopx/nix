{
  pkgs,
  nixosConfig,
  lib,
  defaults,
  nix-colors,
  ...
}: {
  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl

  programs.niri.settings = {
    spawn-at-startup = [
      {command = ["xwayland-satellite"];}
    ];

    # Input configuration
    input = {
      keyboard = {
        xkb = {
          layout = "eu";
        };
        repeat-delay = 600;
        repeat-rate = 25;
        track-layout = "global";
      };

      touchpad = {
        tap = true;
        natural-scroll = true;
        accel-speed = 0.0;
      };

      mouse.accel-speed = 0.0;
      trackpoint.accel-speed = 0.0;
      trackball.accel-speed = 0.0;

      warp-mouse-to-focus = true;
      workspace-auto-back-and-forth = true;
    };

    # Output configuration
    outputs."DP-1" = {
      scale = 2.0;
      background-color = "#${defaults.colorScheme.palette.base02}";
    };

    # Screenshot path
    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png";

    # Prefer server-side decorations
    prefer-no-csd = true;

    # Layout configuration
    layout = {
      gaps = 16;
      struts = {
        left = 0;
        right = 0;
        top = 0;
        bottom = 0;
      };

      focus-ring = {
        enable = true;
        width = 3;
        active.color = "#${defaults.colorScheme.palette.base0D}";
        inactive.color = "#${defaults.colorScheme.palette.base02}";
      };

      border = {
        enable = true;
        width = 1;
        active.color = "#${defaults.colorScheme.palette.base02}";
        inactive.color = "#${defaults.colorScheme.palette.base02}";
      };

      insert-hint = {
        enable = true;
        display.color = "rgb(${nix-colors.lib-core.conversions.hexToRGBString " " defaults.colorScheme.palette.base0D} / 50%)";
      };

      default-column-width.proportion = 0.75;
      preset-column-widths = [
        {proportion = 0.25;}
        {proportion = 0.50;}
        {proportion = 0.75;}
      ];

      center-focused-column = "on-overflow";
      always-center-single-column = true;
    };

    # Cursor configuration
    cursor = {
      theme = "default";
      size = 24;
      hide-when-typing = true;
    };

    # Hotkey overlay
    hotkey-overlay.skip-at-startup = true;

    # Overview
    overview = {
      zoom = 0.7;
      backdrop-color = "#${defaults.colorScheme.palette.base02}";
      # TODO: implement and submit PR to niri-flake
      # workspace-shadow = false;
    };

    # Environment variables
    environment = {
      DISPLAY = ":0";
      # required for nautilus to launch properly (because niri spawn does not set env)
      GIO_EXTRA_MODULES = "${nixosConfig.services.gvfs.package}/lib/gio/modules";
    };

    # Keybindings
    binds = {
      # Application launchers
      "Mod+N".action.spawn = "firefox";
      "Mod+G".action.spawn = "code";
      "Mod+T".action.spawn = "kitty";
      "Mod+V".action.spawn = "nautilus";
      "Mod+Delete".action.spawn = lib.getExe pkgs.mission-center;
      "Mod+Space".action.spawn = lib.getExe pkgs.launcher;

      # Focus navigation
      "Mod+Left".action.focus-column-left = [];
      "Mod+Right".action.focus-column-right = [];

      # Window management
      "Mod+W".action.close-window = [];
      "Mod+Q".action.close-window = [];
      "Mod+C".action.center-window = [];
      "Mod+F".action.maximize-column = [];
      "Mod+R".action.switch-preset-column-width = [];
      "Mod+Return".action.toggle-window-floating = [];
      "Mod+Shift+F".action.fullscreen-window = [];
      "Mod+I".action.consume-or-expel-window-left = [];
      "Mod+O".action.consume-or-expel-window-right = [];

      # Column movement
      "Mod+Shift+Down".action.move-column-to-workspace-down = [];
      "Mod+Shift+End".action.move-workspace-down = [];
      "Mod+Shift+Home".action.move-workspace-up = [];
      "Mod+Shift+Left".action.move-column-left = [];
      "Mod+Shift+Right".action.move-column-right = [];
      "Mod+Shift+Up".action.move-column-to-workspace-up = [];

      # Workspace navigation
      "Mod+Up".action.focus-workspace-up = [];
      "Alt+Up".action.focus-workspace-up = [];
      "Mod+Down".action.focus-workspace-down = [];
      "Alt+Down".action.focus-workspace-down = [];

      # Overview
      "Mod+J".action.toggle-overview = [];

      # Quit
      "Mod+Shift+Ctrl+L".action.quit.skip-confirmation = true;

      # Screenshots
      "Print".action.screenshot = [];
      "Shift+Print".action.screenshot-window = [];

      # Media keys
      "XF86AudioPlay".action.spawn = [
        (lib.getExe pkgs.playerctl)
        "play-pause"
      ];
      "XF86AudioStop".action.spawn = [
        (lib.getExe pkgs.playerctl)
        "pause"
      ];
      "XF86AudioNext".action.spawn = [
        (lib.getExe pkgs.playerctl)
        "next"
      ];
      "XF86AudioPrev".action.spawn = [
        (lib.getExe pkgs.playerctl)
        "previous"
      ];
      "XF86AudioRaiseVolume".action.spawn = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "5%+"
      ];
      "XF86AudioLowerVolume".action.spawn = [
        "${pkgs.wireplumber}/bin/wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "5%-"
      ];
    };

    # Window rules
    window-rules = [
      # Global window styling
      {
        matches = [{}]; # Match all windows
        draw-border-with-background = false;
        geometry-corner-radius = {
          top-left = 8.0;
          top-right = 8.0;
          bottom-left = 8.0;
          bottom-right = 8.0;
        };
        clip-to-geometry = true;
      }

      # Inactive window opacity
      {
        matches = [
          {is-active = false;}
        ];
        opacity = 0.90;
      }

      # Floating windows
      {
        matches = [
          {app-id = "org.gnome.NautilusPreviewer";}
          {app-id = "re.sonny.Commit";}
          {app-id = "^floating.";}
        ];
        open-floating = true;
      }

      # Mission Center with specific size
      {
        matches = [
          {app-id = "io.missioncenter.MissionCenter";}
        ];
        default-column-width.fixed = builtins.elemAt defaults.display.windowSize 0;
        default-window-height.fixed = builtins.elemAt defaults.display.windowSize 1;
        open-floating = true;
      }

      {
        matches = [
          {app-id = "net.knoopx.launcher";}
          {app-id = "net.knoopx.nix-packages";}
          {app-id = "net.knoopx.bookmarks";}
          {app-id = "net.knoopx.scratchpad";}
          {app-id = "net.knoopx.process-manager";}
        ];
        default-column-width.proportion = 0.25;
        open-floating = true;
      }

      # Nautilus privacy
      {
        matches = [
          {app-id = "org.gnome.Nautilus";}
        ];
        block-out-from = "screencast";
      }

      {
        matches = [
          {app-id = "code";}
        ];
        default-column-width.proportion = 1.0;
      }

      {
        matches = [
          {app-id = "net.knoopx.notes";}
        ];
        default-column-width.proportion = 0.75;
      }

      # Half-width windows
      {
        matches = [
          {app-id = "kitty";}
          {app-id = "transmission-gtk";}
          {app-id = "net.knoopx.chat";}
        ];
        default-column-width.proportion = 0.5;
      }

      {
        matches = [
          {app-id = "net.knoopx.music";}
        ];
        default-column-width.proportion = 0.33;
      }

      # Quarter-width windows
      {
        matches = [
          {app-id = "Plexamp";}
          {app-id = "io.bassi.Amberol";}
        ];
        default-column-width.proportion = 0.25;
      }

      # Floating calendar and weather
      {
        matches = [
          {app-id = "org.gnome.Calendar";}
          {app-id = "org.gnome.Weather";}
        ];
        default-column-width.proportion = 0.75;
        open-floating = true;
      }
    ];

    # Layer rules
    layer-rules = [
      {
        matches = [
          {namespace = "notifications";}
        ];
        block-out-from = "screen-capture";
      }
    ];

    # Animations
    animations = {
      enable = true;
      slowdown = 0.6;
    };
  };
}
