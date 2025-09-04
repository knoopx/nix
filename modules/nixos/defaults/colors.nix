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
      # danqing
      # da-one-sea
      # earthsong
      # eighties
      # eris
      # heetch
      # paraiso
      # rose-pine
      # stella
      # rose-pine-moon
      # hopscotch
      # moonlight

      colorScheme = {
        name = "custom";
        palette = {
          base00 = "232136";
          base01 = "2a273f";
          base02 = "393552";
          base03 = "6e6a86";
          base04 = "908caa";
          base05 = "e0def4";
          base06 = "e0def4";
          base07 = "56526e";
          base08 = "eb6f92";
          base09 = "f6c177";
          base0A = "ea9a97";
          base0B = "3e8fb0";
          base0C = "9ccfd8";
          base0D = "c4a7e7";
          base0E = "f6c177";
          base0F = "56526e";
        };
      };
    };
  };
}
