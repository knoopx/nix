{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.defaults = {
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
  };

  config = {
    defaults = {
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
    };
  };
}