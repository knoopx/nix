{
  pkgs,
  lib,
  ...
}:
with lib; {
  options.defaults = {
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
  };

  config = {
    defaults = {
      # https://github.com/tinted-theming/schemes
      colorScheme = {
        name = "custom";
        palette = {
          base00 = "131327";
          base01 = "181030";
          base02 = "292050";
          base03 = "3a3a70";
          base04 = "5e5e90";
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
    };
  };
}
