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
      # rose-pine-moon
      # danqing
      # da-one-sea
      # earthsong
      # eighties
      # eris
      # heetch
      # paraiso
      # rose-pine

      # https://github.com/tinted-theming/schemes
      colorScheme = {
        name = "custom";
        palette = {
          base00 = "2B213C";
          base01 = "362B48";
          base02 = "4D4160";
          base03 = "655978";
          base04 = "7F7192";
          base05 = "998BAD";
          base06 = "B4A5C8";
          base07 = "EBDCFF";
          base08 = "C79987";
          base09 = "8865C6";
          base0A = "C7C691";
          base0B = "ACC79B";
          base0C = "9BC7BF";
          base0D = "A5AAD4";
          base0E = "C594FF";
          base0F = "C7AB87";
        };
      };
    };
  };
}
