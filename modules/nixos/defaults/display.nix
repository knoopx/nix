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
          floatingApps = mkOption {
            type = types.listOf types.str;
            description = "List of app-ids that should open as floating windows.";
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
        columnWidthPercentPresets = [0.25 0.5 0.75];
        appWidths = {};
        floatingApps = [
          "^floating."
          "net.knoopx.bookmarks"
          "net.knoopx.launcher"
          "net.knoopx.nix-packages"
          "net.knoopx.process-manager"
          "net.knoopx.scratchpad"
          "net.knoopx.windows"
          "net.knoopx.wireless-networks"
          "org.gnome.NautilusPreviewer"
          "re.sonny.Commit"
        ];
      };
    };
  };
}