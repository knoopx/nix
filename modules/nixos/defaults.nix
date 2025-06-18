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
      default = "knoopx";
      description = "Default username for the system";
    };

    password = mkOption {
      type = types.str;
      default = config.defaults.username;
      description = "Default password (same as username)";
    };

    fullName = mkOption {
      type = types.str;
      default = "Victor Martinez";
      description = "Full name of the user";
    };

    location = mkOption {
      type = types.str;
      default = "Vilassar de Mar";
      description = "User location";
    };

    primaryEmail = mkOption {
      type = types.str;
      default = "knoopx@gmail.com";
      description = "Primary email address";
    };

    keyMap = mkOption {
      type = types.str;
      default = "eu";
      description = "Keyboard layout mapping";
    };

    timeZone = mkOption {
      type = types.str;
      default = "Europe/Madrid";
      description = "System timezone";
    };

    defaultLocale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "Default system locale";
    };

    region = mkOption {
      type = types.str;
      default = "es_ES.UTF-8";
      description = "Regional locale settings";
    };

    avatarImage = mkOption {
      type = types.path;
      default = pkgs.fetchurl {
        url = "https://gravatar.com/userimage/10402619/9d663d9a46ad2c752bf6cfeb93cff4fd.jpeg?size=512";
        sha256 = "sha256-raMsbyJQgf7JPMvZtAFOBIBwFg8V7HpmtERO9J/50qQ=";
      };
      description = "User avatar image";
    };

    editor = mkOption {
      type = types.str;
      default = "re.sonny.Commit";
      description = "Default text editor";
    };

    pubKeys = mkOption {
      type = types.submodule {
        options = {
          url = mkOption {
            type = types.str;
            default = "https://github.com/${config.defaults.username}.keys";
            description = "URL to fetch public keys from";
          };
          sha256 = mkOption {
            type = types.str;
            default = "sha256-385krE9Aoea23aQ3FJo2kpPtRrIOwxxXCCt43gHEo0Q=";
            description = "SHA256 hash of the public keys";
          };
        };
      };
      default = {};
      description = "Public keys configuration";
    };

    fonts = mkOption {
      type = types.submodule {
        options = {
          sizes = mkOption {
            type = types.submodule {
              options = {
                applications = mkOption {
                  type = types.int;
                  default = 11;
                  description = "Font size for applications";
                };
              };
            };
            default = {};
            description = "Font size configuration";
          };

          sansSerif = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  default = "Inter";
                  description = "Sans-serif font name";
                };
                package = mkOption {
                  type = types.package;
                  default = pkgs.inter;
                  description = "Sans-serif font package";
                };
              };
            };
            default = {};
            description = "Sans-serif font configuration";
          };

          serif = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  default = "Roboto Slab";
                  description = "Serif font name";
                };
                package = mkOption {
                  type = types.package;
                  default = pkgs.roboto;
                  description = "Serif font package";
                };
              };
            };
            default = {};
            description = "Serif font configuration";
          };

          emoji = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  default = "Twitter Color Emoji";
                  description = "Emoji font name";
                };
                package = mkOption {
                  type = types.package;
                  default = pkgs.twitter-color-emoji;
                  description = "Emoji font package";
                };
              };
            };
            default = {};
            description = "Emoji font configuration";
          };

          monospace = mkOption {
            type = types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  default = "JetBrainsMono Nerd Font";
                  description = "Monospace font name";
                };
                package = mkOption {
                  type = types.package;
                  default = pkgs.nerd-fonts.jetbrains-mono;
                  description = "Monospace font package";
                };
              };
            };
            default = {};
            description = "Monospace font configuration";
          };
        };
      };
      default = {};
      description = "Font configuration";
    };

    colorScheme = mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            default = "custom";
            description = "Color scheme name";
          };
          palette = mkOption {
            type = types.submodule {
              options = {
                base00 = mkOption {
                  type = types.str;
                  default = "131327";
                  description = "Base color 00";
                };
                base01 = mkOption {
                  type = types.str;
                  default = "191935";
                  description = "Base color 01";
                };
                base02 = mkOption {
                  type = types.str;
                  default = "25254b";
                  description = "Base color 02";
                };
                base03 = mkOption {
                  type = types.str;
                  default = "2d2b55";
                  description = "Base color 03";
                };
                base04 = mkOption {
                  type = types.str;
                  default = "494685";
                  description = "Base color 04";
                };
                base05 = mkOption {
                  type = types.str;
                  default = "e1efff";
                  description = "Base color 05 (text)";
                };
                base06 = mkOption {
                  type = types.str;
                  default = "e5e4fb";
                  description = "Base color 06";
                };
                base07 = mkOption {
                  type = types.str;
                  default = "fad000";
                  description = "Base color 07";
                };
                base08 = mkOption {
                  type = types.str;
                  default = "ff628c";
                  description = "Base color 08";
                };
                base09 = mkOption {
                  type = types.str;
                  default = "ffb454";
                  description = "Base color 09";
                };
                base0A = mkOption {
                  type = types.str;
                  default = "ffee80";
                  description = "Base color 0A";
                };
                base0B = mkOption {
                  type = types.str;
                  default = "a5ff90";
                  description = "Base color 0B";
                };
                base0C = mkOption {
                  type = types.str;
                  default = "80fcff";
                  description = "Base color 0C";
                };
                base0D = mkOption {
                  type = types.str;
                  default = "fad000";
                  description = "Base color 0D";
                };
                base0E = mkOption {
                  type = types.str;
                  default = "faefa5";
                  description = "Base color 0E";
                };
                base0F = mkOption {
                  type = types.str;
                  default = "fb94ff";
                  description = "Base color 0F";
                };
              };
            };
            default = {};
            description = "Color palette configuration";
          };
        };
      };
      default = {};
      description = "Color scheme configuration following base16 scheme";
    };

    display = mkOption {
      type = types.submodule {
        options = {
          width = mkOption {
            type = types.int;
            default = 1920 * 2;
            description = "Display width in pixels";
          };
          height = mkOption {
            type = types.int;
            default = 1080 * 2;
            description = "Display height in pixels";
          };
          windowSize = mkOption {
            type = types.listOf types.int;
            default = [1240 900];
            description = "Default window size [width, height]";
          };
          sidebarWidth = mkOption {
            type = types.int;
            default = 200;
            description = "Default sidebar width in pixels";
          };
          defaultColumnWidthPercent = mkOption {
            type = types.float;
            default = 0.75;
            description = "Default column width";
          };
          columnWidthPercentPresets = mkOption {
            type = types.listOf types.float;
            default = [0.25 0.5 0.75];
            description = "List of column width presets as percentages";
          };
          appWidths = mkOption {
            type = types.attrsOf types.float;
            default = {};
            description = "Mapping of app-id to default column width proportion (0.0-1.0)";
          };
          floatingApps = mkOption {
            type = types.listOf types.str;
            default = [
              "org.gnome.NautilusPreviewer"
              "re.sonny.Commit"
              "^floating."
              "net.knoopx.launcher"
              "net.knoopx.nix-packages"
              "net.knoopx.bookmarks"
              "net.knoopx.scratchpad"
              "net.knoopx.windows"
              "net.knoopx.process-manager"
            ];
            description = "List of app-ids that should open as floating windows.";
          };
        };
      };
      default = {};
      description = "Display configuration settings";
    };
  };

  config = {
    # Set default values for the module - this ensures all options are properly initialized
    defaults = mkDefault {};
  };
}
