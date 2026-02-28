{lib, ...}:
with lib; {
  options.defaults = {
    display = mkOption {
      type = types.submodule {
        options = {
          width = mkOption {
            type = types.int;
            description = "Display width in pixels";
          };
          height = mkOption {
            type = types.int;
            description = "Display height in pixels";
          };
          idleTimeout = mkOption {
            type = types.int;
            description = "Idle timeout in seconds before powering off monitors";
          };
          windowSize = mkOption {
            type = types.listOf types.int;
            description = "Default window size [width, height]";
          };
          sidebarWidth = mkOption {
            type = types.int;
            description = "Default sidebar width in pixels";
          };
          defaultColumnWidthPercent = mkOption {
            type = types.float;
            description = "Default column width";
          };
          columnWidthPercentPresets = mkOption {
            type = types.listOf types.float;
            description = "List of column width percentage presets";
          };
          windowRules = mkOption {
            type = types.listOf types.attrs;
            description = "List of window rules for the window manager";
          };
          layerRules = mkOption {
            type = types.listOf types.attrs;
            description = "List of layer rules for the window manager";
          };
        };
      };
      description = "Display configuration settings";
    };
  };

  config = {
    defaults = {
      display = {
        width = 1920 * 2;
        height = 1080 * 2;
        idleTimeout = 5 * 60;
        windowSize = [1240 900];
        sidebarWidth = 200;
        defaultColumnWidthPercent = 0.5;
        columnWidthPercentPresets = [0.66 0.5 0.33];

        windowRules = [
          {
            draw-border-with-background = false;
            geometry-corner-radius = {
              top-left = 8.0;
              top-right = 8.0;
              bottom-left = 8.0;
              bottom-right = 8.0;
            };
            clip-to-geometry = true;
          }
          {
            matches = [{is-floating = true;}];
            geometry-corner-radius = {
              top-left = 16.0;
              top-right = 16.0;
              bottom-left = 16.0;
              bottom-right = 16.0;
            };
          }
          {
            matches = [{app-id = "scrcpy";}];
            open-floating = false;
            default-column-width.fixed = 472;
            geometry-corner-radius = {
              top-left = 18.0;
              top-right = 18.0;
              bottom-left = 18.0;
              bottom-right = 18.0;
            };
          }
          {
            matches = [{app-id = "org.gnome.NautilusPreviewer";}];
            open-floating = true;
            default-window-height.proportion = 0.75;
          }
          {
            matches = [
              {app-id = "io.bassi.Amberol";}
              {app-id = "Plexamp";}
              {app-id = "net.knoopx.camper";}
            ];
            default-column-width.proportion = 0.25;
          }
          {
            matches = [
              {title = "/dev/video0";}
            ];
            default-column-width.fixed = 400;
            default-window-height.fixed = 300;
            open-floating = true;
            open-focused = false;
            default-floating-position = {
              x = 16;
              y = 16;
              relative-to = "bottom-right";
            };
          }
          {
            matches = [
              {app-id = "mpv";}
            ];
            open-fullscreen = true;
          }
          {
            matches = [
              {app-id = "scrcpy";}
              {title = "[Ll]ogin";}
              {title = "Photos";}
              {title = "[Ss]ign-?in";}
              {title = "[Pp]assword";}
              {title = "Calendar";}
              {title = "Meet";}
              {title = "Notion";}
              {title = "Slack";}
              {title = "Reddit";}
              {title = "Telegram";}
              {title = "Discord";}
              {title = "WhatsApp";}
              {title = "Vicinae Launcher";}
              {title = "Gmail";}
              {app-id = "org.gnome.Nautilus";}
            ];
            block-out-from = "screen-capture";
          }
          {
            matches = [{is-active = false;}];
            opacity = 0.9;
          }
          {
            matches = [{is-floating = true;}];
            opacity = 1.0;
          }
        ];

        layerRules = [
          {
            matches = [{namespace = "notifications";}];
            block-out-from = "screen-capture";
          }
          {
            matches = [{namespace = "^wallpaper$";}];
            place-within-backdrop = true;
          }
        ];
      };
    };
  };
}
