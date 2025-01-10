{
  pkgs,
  defaults,
  ...
}: let
  palette = pkgs.writeTextFile {
    name = "gnome-shell-palette.css";

    text = with defaults.colorScheme.palette; ''
      $blue_1: #${base0D};
      $blue_2: #${base0D};
      $blue_3: #${base0D};
      $blue_4: #${base0D};
      $blue_5: #${base0D};

      $green_1: #${base0B};
      $green_2: #${base0B};
      $green_3: #${base0B};
      $green_4: #${base0B};
      $green_5: #${base0B};

      $yellow_1: #${base0A};
      $yellow_2: #${base0A};
      $yellow_3: #${base0A};
      $yellow_4: #${base0A};
      $yellow_5: #${base0A};

      $orange_1: #${base09};
      $orange_2: #${base09};
      $orange_3: #${base09};
      $orange_4: #${base09};
      $orange_5: #${base09};

      $red_1: #${base08};
      $red_2: #${base08};
      $red_3: #${base08};
      $red_4: #${base08};
      $red_5: #${base08};

      $purple_1: #${base07};
      $purple_2: #${base07};
      $purple_3: #${base07};
      $purple_4: #${base07};
      $purple_5: #${base07};

      $brown_1: #${base0E};
      $brown_2: #${base0E};
      $brown_3: #${base0E};
      $brown_4: #${base0E};
      $brown_5: #${base0E};

      $light_1: #${base05};
      $light_2: #f6f5f4;
      $light_3: #deddda;
      $light_4: #c0bfbc;
      $light_5: #9a9996;

      $dark_1: #${base04};
      $dark_2: #${base03};
      $dark_3: #${base02};
      $dark_4: #${base00};
      $dark_5: #${base01};
    '';
  };
  # theme = pkgs.stdenv.mkDerivation {
  #   name = "gnome-shell-theme.gresource";
  #   nativeBuildInputs = with pkgs; [
  #     sass
  #     glib.dev
  #   ];
  #   src = pkgs.gnome-shell.src;
  #   preConfigure = ''
  #     # cp ${palette} data/theme/gnome-shell-sass/_palette.scss
  #     sed -i '1s/^/$selected_fg_color: #${defaults.colorScheme.palette.base07}; $selected_bg_color: #${defaults.colorScheme.palette.base07};\n/' \
  #       data/theme/gnome-shell-sass/_default-colors.scss
  #     substituteInPlace data/theme/gnome-shell-sass/{*,**/*}.scss \
  #       --replace-warn '-st-accent-color' '$selected_bg_color' \
  #       --replace-warn '-st-accent-fg-color' '$selected_fg_color'
  #   '';
  #   buildPhase = ''
  #     sass data/theme/gnome-shell-dark.scss > data/theme/gnome-shell-dark.css
  #     sass data/theme/gnome-shell-light.scss > data/theme/gnome-shell-light.css
  #     sass data/theme/gnome-shell-high-contrast.scss > data/theme/gnome-shell-high-contrast.css
  #     glib-compile-resources --sourcedir=data/theme data/gnome-shell-theme.gresource.xml
  #   '';
  #   installPhase = ''
  #     cp data/gnome-shell-theme.gresource $out
  #   '';
  # };
in {
  nixpkgs.overlays = [
    # (final: prev: {
    #   gnome-shell = prev.gnome-shell.overrideAttrs (oldAttrs: {
    #     postFixup =
    #       (oldAttrs.postFixup or "")
    #       + ''
    #         cp ${theme} $out/share/gnome-shell/gnome-shell-theme.gresource
    #       '';
    #   });
    # })
    (final: prev: {
      final.catppuccin-mocha-gnome-shell-theme = prev.catppuccin-mocha-gnome-shell-theme.overrideAttrs (oldAttrs: {
        preConfigure = ''
          sed -i '1s/^/$selected_fg_color: #${defaults.colorScheme.palette.base07}; $selected_bg_color: #${defaults.colorScheme.palette.base07};\n/' \
            data/theme/gnome-shell-sass/_default-colors.scss

          substituteInPlace data/theme/gnome-shell-sass/{*,**/*}.scss \
            --replace-warn '-st-accent-color' '$selected_bg_color' \
            --replace-warn '-st-accent-fg-color' '$selected_fg_color'
        '';
        # postFixup =
        #   (oldAttrs.postFixup or "")
        #   + ''
        #     cp ${theme} $out/share/gnome-shell/gnome-shell-theme.gresource
        #   '';
      });
    })
  ];
}
