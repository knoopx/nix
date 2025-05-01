{
  defaults,
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
  programs.niri = {
    package = pkgs.niri-unstable;
    settings = {
      environment = {
        _EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        GDK_BACKEND = "wayland";
        LIBVA_DRIVER_NAME = "nvidia";
        MOZ_ENABLE_WAYLAND = "1";
        NVD_BACKEND = "direct";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "all";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland";
        WLR_BACKEND = "vulkan";
        WLR_DRM_NO_ATOMIC = "1";
        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER = "vulkan";
        XDG_SESSION_TYPE = "wayland";
        DISPLAY = ":0";
      };

      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;

      spawn-at-startup = [
        {command = [(lib.getExe pkgs.xwayland-satellite)];}
        {command = [(lib.getExe pkgs.mako)];}
        {command = [(lib.getExe pkgs.swaybg) "--image" wallpaper.outPath];}
        {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
        {command = ["ags" "run"];}
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
          background-color = "#003300";
          # backdrop-color = "#001100";
        };
      };

      # overview = {
      #   zoom = 0.75;
      # };

      # workspaces = {
      #   "surf" = {};
      #   "dev" = {};
      #   "chat" = {};
      #   "org" = {};
      #   "media" = {};
      #   "misc" = {};
      # };

      layout = {
        always-center-single-column = true;
        shadow.enable = true;
        default-column-width = {proportion = 0.75;};

        border = {
          enable = true;
          width = 1;
          active.color = "#${defaults.colorScheme.palette.base02}";
          inactive.color = "#${defaults.colorScheme.palette.base02}";
        };

        focus-ring = let
          gradient = {
            from = "#${defaults.colorScheme.palette.base07}";
            to = "#${defaults.colorScheme.palette.base0D}";
            angle = -45;
            in' = "oklch longer hue";
          };
        in {
          width = 3;
          active.color = defaults.colorScheme.palette.base0D;
          # active.gradient = gradient;
          inactive.color = defaults.colorScheme.palette.base02;
        };

        preset-column-widths = [
          {proportion = 0.25;}
          {proportion = 0.5;}
          {proportion = 0.75;}
        ];
      };

      binds = with config.lib.niri.actions; let
        set-volume = spawn "${pkgs.wireplumber}/bin/wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@";
        playerctl = spawn "${lib.getExe pkgs.playerctl}";
      in {
        "Mod+T".action.spawn = ["kitty"];
        "Mod+G".action.spawn = ["code"];
        "Mod+B".action.spawn = ["firefox"];
        "Mod+Delete".action.spawn = [(lib.getExe pkgs.mission-center)];
        "Mod+Shift+Ctrl+L".action.spawn = ["niri" "msg" "action" "quit" "-s"];
        # "Mod+Shift+Ctrl+L".action = quit;
        "Mod+D".action.spawn = ["ags" "toggle" "launcher"];
        "Mod+Slash".action = show-hotkey-overlay;

        "Mod+W".action = close-window;
        "Mod+Q".action = close-window;
        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        # "Mod+Shift+F".action = expand-column-to-available-width;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Space".action = toggle-window-floating;
        "Mod+C".action = center-window;

        "Mod+I".action = consume-or-expel-window-left;
        "Mod+O".action = consume-or-expel-window-right;
        "Mod+J".action = toggle-overview;
        # "Super+Super_L".action = toggle-overview;

        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;

        "Alt+Left".action = focus-column-left;
        "Alt+Right".action = focus-column-right;
        "Alt+Down".action = focus-workspace-down;
        "Alt+Up".action = focus-workspace-up;

        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Right".action = move-column-right;
        "Mod+Shift+Up".action = move-column-to-workspace-up;
        "Mod+Shift+Down".action = move-column-to-workspace-down;

        "Mod+Shift+Home".action = move-workspace-up;
        "Mod+Shift+End".action = move-workspace-down;
        "Mod+Tab".action.spawn = [(lib.getExe niri-cycle)];
        "Mod+Escape".action.spawn = [(lib.getExe niri-cycle) "--app"];
        "Shift+Mod+Tab".action.spawn = [(lib.getExe niri-cycle) "--reverse"];
        "Shift+Mod+Escape".action.spawn = [(lib.getExe niri-cycle) "--app" "--reverse"];

        # "Print".action.spawn = [(lib.getExe pkgs.kooha)];
        "Print".action = screenshot;
        # "Ctrl+Print".action = screenshot-screen;
        "Shift+Print".action = screenshot-window;

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

      # https://github.com/YaLTeR/niri/blob/main/wiki/Configuration:-Window-Rules.md
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
            {app-id = "io.missioncenter.MissionCenter";}
          ];
          default-column-width = {fixed = lib.elemAt defaults.display.windowSize 0;};
          default-window-height = {fixed = lib.elemAt defaults.display.windowSize 1;};
          open-floating = true;
        }

        {
          matches = [
            {app-id = "^org\.gnome\.Nautilus$";}
          ];
          block-out-from = "screencast";
          # block-out-from = ["screencast" "screen-capture"];
        }

        {
          matches = [
            {app-id = "^kitty$";}
          ];
          default-column-width = {proportion = 0.5;};
        }

        {
          matches = [
            {
              app-id = "Plexamp";
            }
          ];
          default-column-width = {proportion = 0.25;};
          # open-floating = true;
        }

        {
          matches = [
            {
              app-id = "org.gnome.Calendar";
            }
            {
              app-id = "org.gnome.Weather";
            }
            {
              app-id = "com.github.qarmin.czkawka";
            }
          ];
          default-column-width = {proportion = 0.75;};
          open-floating = true;
        }
      ];
    };
  };
}
