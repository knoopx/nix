{pkgs, ...}: colorScheme: let
  colors = pkgs.writeTextFile {
    name = "gnome-shell-colors.scss";

    text = with colorScheme; ''
      $destructive_bg_color: #${base08};
      $destructive_fg_color: #${base00};
      $destructive_color: #${base08};

      $success_bg_color: #${base0B};
      $success_fg_color: #${base00};
      $success_color: #${base0B};

      $warning_bg_color: #${base0A};
      $warning_fg_color: #${base00};
      $warning_color: #${base0A};

      $error_bg_color: #${base08};
      $error_fg_color: #${base00};
      $error_color: #${base08};

      $selected_bg_color: #${base0D};
      $selected_fg_color: #${base00};

      $link_color: #${base0D};
      $link_visited_color: transparentize($link_color, 0.4);

      $background_mix_factor: 0%;
      $border_opacity: 1;

      $shadow_color: transparent;
      $text_shadow_color: transparent;

      $focus_color: $selected_bg_color;
      $focus_border_color: transparentize(#${base05}, 0.5);

      $base_color: #${base01};
      $bg_color: #${base00};
      $fg_color: #${base05};

      $osd_fg_color: #${base05};
      $osd_bg_color: #${base01};

      $system_base_color: #${base00};
      $system_fg_color: #${base05};

      $panel_bg_color: #${base01};
      $panel_fg_color: #${base05};

      $card_bg_color: #${base01};
      $card_shadow_color: transparent;
      $card_shadow_border_color: transparent;

      $borders_color: transparentize(#${base05}, 0.8);
      $outer_borders_color: transparentize(#${base05}, 0.9);

      $osd_borders_color: $borders_color;
      $osd_outer_borders_color: $outer_borders_color;

      $system_bg_color: #${base00};
      $system_borders_color: $borders_color;
      $system_insensitive_fg_color: #${base05};
      $system_overlay_bg_color: #${base01};

      $insensitive_fg_color: #${base04};
      $insensitive_bg_color: #${base00};
      $insensitive_borders_color: $borders_color;

      $checked_bg_color: #${base01};
      $checked_fg_color: #${base05};

      $hover_bg_color: #${base01};
      $hover_fg_color: #${base05};

      $active_bg_color: #${base01};
      $active_fg_color: #${base05};

      $accent_borders_color: transparentize(#${base0D}, 0.5);

      $_base_color_light: #eeeeee;
      $light_1: #ffffff;
      $red_4: #${base08};
      $orange_3: #${base09};
      $orange_4: #${base09};

      $selected_fg_color: #${base07};
      $selected_bg_color: #${base07};
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    name = "gnome-shell-theme";
    nativeBuildInputs = with pkgs; [
      sass
      glib.dev
    ];
    src = pkgs.gnome-shell.src;
    preConfigure = ''
      cp ${colors} data/theme/gnome-shell-sass/_colors.scss
      cp ${colors} data/theme/gnome-shell-sass/_default-colors.scss

      substituteInPlace data/theme/gnome-shell-sass/{*,**/*}.scss \
        --replace-warn '-st-accent-color' '$selected_bg_color' \
        --replace-warn '-st-accent-fg-color' '$selected_fg_color'

    '';
    buildPhase = ''
      sass data/theme/gnome-shell-dark.scss > data/theme/gnome-shell-dark.css
      sass data/theme/gnome-shell-light.scss > data/theme/gnome-shell-light.css
      sass data/theme/gnome-shell-high-contrast.scss > data/theme/gnome-shell-high-contrast.css
      glib-compile-resources --sourcedir=data/theme data/gnome-shell-theme.gresource.xml
    '';
    installPhase = ''
      mkdir -p $out/share/gnome-shell
      cp data/theme/gnome-shell-{light,dark}.css $out/share/gnome-shell
      cp data/gnome-shell-theme.gresource $out/share/gnome-shell/gnome-shell-theme.gresource
    '';
  }
