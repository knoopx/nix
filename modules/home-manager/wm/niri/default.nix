{
  defaults,
  anyrun,
  pkgs,
  lib,
  config,
  ...
}: let
  wallpaper = pkgs.theming.mkSVGPatternWallpaper {
    style = pkgs.pattern-monster.doodle-1;
    scale = 4;
    colors = with defaults.colorScheme.palette; [
      base01
      base00
      base02
      base03
      base04
    ];
  };
in {
  home.packages = with pkgs; [
    kooha
  ];

  programs.anyrun = {
    enable = true;
    config = {
      x = {fraction = 0.5;};
      y = {fraction = 0.1;};
      width = {fraction = 0.3;};
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = null;

      plugins = with anyrun.packages.${pkgs.system}; [
        applications
        rink
        translate
        dictionary
        websearch
      ];
    };
  };

  # https://github.com/sodiboo/niri-flake/blob/main/docs.md
  # https://github.com/YaLTeR/niri/blob/main/resources/default-config.kdl
  programs.niri = {
    package = pkgs.niri-unstable;
    settings = {
      environment = {
        CLUTTER_BACKEND = "wayland";
        DISPLAY = null;
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
      };
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      spawn-at-startup = [
        {command = [(lib.getExe pkgs.swaybg) "--image" wallpaper.outPath];}
        {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
      ];

      input = {
        keyboard.xkb.layout = defaults.keyMap;
        warp-mouse-to-focus = true;
        workspace-auto-back-and-forth = true;
      };

      cursor = {
        hide-when-typing = true;
      };

      outputs = {
        "DP-1" = {
          scale = 2.0;
        };
      };

      layout = {
        focus-ring = {
          width = 3;
          active.gradient = {
            from = "#${defaults.colorScheme.palette.base07}";
            to = "#${defaults.colorScheme.palette.base0D}";
            angle = -45;
            in' = "oklch longer hue";
          };
        };
        shadow = {
          enable = true;
        };

        border = {
          enable = true;
          width = 1;
          active.color = "#${defaults.colorScheme.palette.base02}";
          inactive.color = "#${defaults.colorScheme.palette.base02}";
        };

        always-center-single-column = true;
        preset-column-widths = [
          {proportion = 0.25;}
          {proportion = 0.5;}
          {proportion = 0.75;}
        ];
        default-column-width = {proportion = 0.75;};
      };

      binds = with config.lib.niri.actions; let
        set-volume = spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@";
        playerctl = spawn "${lib.getExe pkgs.playerctl}";
      in {
        "Mod+T".action.spawn = ["kitty"];
        "Mod+B".action.spawn = ["firefox"];
        "Mod+Delete".action.spawn = ["kitty" "btop"];
        "Mod+Shift+Ctrl+L".action = quit;
        "Mod+D".action = spawn (lib.getExe pkgs.anyrun);
        "Mod+Slash".action = show-hotkey-overlay;

        "Mod+W".action = close-window;
        "Mod+Q".action = close-window;
        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        # "Mod+Shift+F".action = expand-column-to-available-width;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Space".action = toggle-window-floating;
        "Mod+C".action = center-window;

        "Mod+O".action = toggle-overview;

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-column-to-workspace-up;
        "Mod+Shift+Down".action = move-column-to-workspace-down;

        "Mod+Shift+Home".action = move-workspace-up;
        "Mod+Shift+End".action = move-workspace-down;
        "Mod+Tab".action = focus-workspace-previous;

        # "Print".action.spawn = [(lib.getExe pkgs.kooha)];
        "Print".action = screenshot;
        # "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        "XF86AudioPlay".action = playerctl "play-pause";
        "XF86AudioStop".action = playerctl "pause";
        "XF86AudioPrev".action = playerctl "previous";
        "XF86AudioNext".action = playerctl "next";
        "XF86AudioRaiseVolume".action = set-volume "5%+";
        "XF86AudioLowerVolume".action = set-volume "5%-";
      };

      layer-rules = [
        {
          matches = [
            {namespace = "notifications";}
          ];
          block-out-from = "screen-capture";
        }
      ];

      window-rules = [
        {
          draw-border-with-background = false;
          geometry-corner-radius = let
            r = 8.0;
          in {
            top-left = r;
            top-right = r;
            bottom-left = r;
            bottom-right = r;
          };
          clip-to-geometry = true;
        }

        {
          matches = [
            {is-active = false;}
          ];
          opacity = 0.90;
        }

        {
          matches = [
            {app-id = "^org\.gnome\.NautilusPreviewer$";}
          ];

          default-column-width = {};
          open-floating = true;
        }

        {
          matches = [
            {app-id = "^org\.gnome\.Nautilus$";}
          ];
          block-out-from = "screen-capture";
        }

        # {
        #   matches = [
        #     {app-id = "^com\.mitchellh\.ghostty$";}
        #     {app-id = "^foot$";}
        #     {app-id = "^kitty$";}
        #     {app-id = "^org\.wezfurlong\.wezterm$";}
        #   ];
        #   open-floating = true;
        # }
      ];
    };
  };
}
