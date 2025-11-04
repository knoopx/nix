{
  config,
  lib,
  ...
}:
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
            description = "List of column width presets as percentages";
          };
          appWidths = mkOption {
            type = types.attrsOf types.float;
            description = "Mapping of app-id to default column width proportion (0.0-1.0)";
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
        defaultColumnWidthPercent = 0.75;
        columnWidthPercentPresets = [0.75 0.5 0.25];

        appWidths = {
          "code" = 1.0;
          "io.bassi.Amberol" = 0.25;
          "kitty" = 0.75;
          "net.knoopx.bookmarks" = 0.25;
          "net.knoopx.chat" = 0.5;
          "net.knoopx.launcher" = 0.25;
          "net.knoopx.music" = 0.33;
          "net.knoopx.nix-packages" = 0.25;
          "net.knoopx.notes" = 0.75;
          "net.knoopx.process-manager" = 0.25;
          "net.knoopx.scratchpad" = 0.25;
          "net.knoopx.windows" = 0.25;
          "org.gnome.Calendar" = 0.75;
          "org.gnome.Weather" = 0.75;
          "Plexamp" = 0.25;
          "transmission-gtk" = 0.5;
        };
      };
    };
  };
}
