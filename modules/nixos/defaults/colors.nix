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
          base00 = "101033";
          base01 = "161641";
          base02 = "24245d";
          base03 = "3e3e76";
          base04 = "616194";
          base05 = "f8f8f8";
          base06 = "f0f0f4";
          base07 = "faf9fa";
          base08 = "ff6565";
          base09 = "68a5ff";
          base0A = "fad000";
          base0B = "a5ff90";
          base0C = "2feeda";
          base0D = "ff6565";
          base0E = "faefa5";
          base0F = "fb94ff";
        };
      };
    };
  };
}
