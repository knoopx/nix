{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.defaults = {
    username = mkOption {
      type = types.str;
      description = "Default username for the system";
    };
    password = mkOption {
      type = types.str;
      description = "Default password (same as username)";
    };
    fullName = mkOption {
      type = types.str;
      description = "Full name of the user";
    };
    location = mkOption {
      type = types.str;
      description = "User location";
    };
    primaryEmail = mkOption {
      type = types.str;
      description = "Primary email address";
    };
    keyMap = mkOption {
      type = types.str;
      description = "Keyboard layout mapping";
    };
    timeZone = mkOption {
      type = types.str;
      description = "System timezone";
    };
    defaultLocale = mkOption {
      type = types.str;
      description = "Default system locale";
    };
    region = mkOption {
      type = types.str;
      description = "Regional locale settings";
    };
    avatarImage = mkOption {
      type = types.path;
      description = "User avatar image";
    };
    editor = mkOption {
      type = types.str;
      description = "Default text editor";
    };
    pubKeys = mkOption {
      type = types.path;
      description = "Public keys configuration";
    };
    fonts = mkOption {
      type = types.submodule {
        options = {
          baseSize = mkOption {
            type = types.int;
            description = "Base font size for applications";
          };
          sansSerif = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  description = "Sans-serif font name";
                };
                package = mkOption {
                  type = types.package;
                  description = "Sans-serif font package";
                };
              };
            };
            description = "Sans-serif font configuration";
          };
          serif = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  description = "Serif font name";
                };
                package = mkOption {
                  type = types.package;
                  description = "Serif font package";
                };
              };
            };
            description = "Serif font configuration";
          };
          emoji = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  description = "Emoji font name";
                };
                package = mkOption {
                  type = types.package;
                  description = "Emoji font package";
                };
              };
            };
            description = "Emoji font configuration";
          };
          monospace = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  description = "Monospace font name";
                };
                package = mkOption {
                  type = types.package;
                  description = "Monospace font package";
                };
              };
            };
            description = "Monospace font configuration";
          };
        };
      };
      description = "Font configuration";
    };
    colorScheme = mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Color scheme name";
          };
          palette = mkOption {
            type = types.submodule {
              options = {
                base00 = mkOption {
                  type = types.str;
                  description = "Base color 00";
                };
                base01 = mkOption {
                  type = types.str;
                  description = "Base color 01";
                };
                base02 = mkOption {
                  type = types.str;
                  description = "Base color 02";
                };
                base03 = mkOption {
                  type = types.str;
                  description = "Base color 03";
                };
                base04 = mkOption {
                  type = types.str;
                  description = "Base color 04";
                };
                base05 = mkOption {
                  type = types.str;
                  description = "Base color 05";
                };
                base06 = mkOption {
                  type = types.str;
                  description = "Base color 06";
                };
                base07 = mkOption {
                  type = types.str;
                  description = "Base color 07";
                };
                base08 = mkOption {
                  type = types.str;
                  description = "Base color 08";
                };
                base09 = mkOption {
                  type = types.str;
                  description = "Base color 09";
                };
                base0A = mkOption {
                  type = types.str;
                  description = "Base color 0A";
                };
                base0B = mkOption {
                  type = types.str;
                  description = "Base color 0B";
                };
                base0C = mkOption {
                  type = types.str;
                  description = "Base color 0C";
                };
                base0D = mkOption {
                  type = types.str;
                  description = "Base color 0D";
                };
                base0E = mkOption {
                  type = types.str;
                  description = "Base color 0E";
                };
                base0F = mkOption {
                  type = types.str;
                  description = "Base color 0F";
                };
              };
            };
            description = "Color palette configuration";
          };
        };
      };
      description = "Color scheme configuration following base16 scheme";
    };
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
    # Set default values for the module - this ensures all options are properly initialized
    defaults = {
      username = "knoopx";
      password = "knoopx";
      fullName = "Victor Martinez";
      location = "Vilassar de Mar";
      primaryEmail = "knoopx@gmail.com";
      keyMap = "eu";
      timeZone = "Europe/Madrid";
      defaultLocale = "en_US.UTF-8";
      region = "es_ES.UTF-8";
      avatarImage = pkgs.fetchurl {
        url = "https://avatars.githubusercontent.com/u/100993?s=512&u=1703477b683272ffb744f2d41d4b7599010d239b&v=4";
        sha256 = "sha256-bMHK0ZX9oZYJPI9FqYOcXMQonzipb0Hmbb4MnlhoiLY=";
      };
      editor = "re.sonny.Commit";
      pubKeys = pkgs.fetchurl {
        url = "https://github.com/${config.defaults.username}.keys";
        sha256 = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
      };
      fonts = {
        baseSize = 11;
        sansSerif = {
          name = "Inter";
          package = pkgs.inter;
        };
        serif = {
          name = "Roboto Slab";
          package = pkgs.roboto;
        };
        emoji = {
          name = "Twitter Color Emoji";
          package = pkgs.twitter-color-emoji;
        };
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
      };
      colorScheme = {
        name = "custom";
        palette = {
          base00 = "131327";
          base01 = "191935";
          base02 = "25254b";
          base03 = "2d2b55";
          base04 = "494685";
          base05 = "e1efff";
          base06 = "e5e4fb";
          base07 = "fad000";
          base08 = "ff628c";
          base09 = "ffb454";
          base0A = "ffee80";
          base0B = "a5ff90";
          base0C = "80fcff";
          base0D = "fad000";
          base0E = "faefa5";
          base0F = "fb94ff";
        };
      };
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
