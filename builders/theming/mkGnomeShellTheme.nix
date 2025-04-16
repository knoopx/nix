{pkgs, ...}: colorScheme: let
  colors = pkgs.writeTextFile {
    name = "gnome-shell-colors.scss";
    text = with colorScheme; ''
      $blue_1: lighten(#${base0D}, 20%);
      $blue_2: lighten(#${base0D}, 10%);
      $blue_3: #${base0D};
      $blue_4: darken(#${base0D}, 10%);
      $blue_5: darken(#${base0D}, 20%);

      $green_1: lighten(#${base0B}, 20%);
      $green_2: lighten(#${base0B}, 10%);
      $green_3: #${base0B};
      $green_4: darken(#${base0B}, 10%);
      $green_5: darken(#${base0B}, 20%);

      $yellow_1: lighten(#${base0A}, 20%);
      $yellow_2: lighten(#${base0A}, 10%);
      $yellow_3: #${base0A};
      $yellow_4: darken(#${base0A}, 10%);
      $yellow_5: darken(#${base0A}, 20%);

      $orange_1: lighten(#${base09}, 20%);
      $orange_2: lighten(#${base09}, 10%);
      $orange_3: #${base09};
      $orange_4: darken(#${base09}, 10%);
      $orange_5: darken(#${base09}, 20%);

      $red_1: lighten(#${base08}, 20%);
      $red_2: lighten(#${base08}, 10%);
      $red_3: #${base08};
      $red_4: darken(#${base08}, 10%);
      $red_5: darken(#${base08}, 20%);

      $purple_1: lighten(#${base0E}, 20%);
      $purple_2: lighten(#${base0E}, 10%);
      $purple_3: #${base0E};
      $purple_4: darken(#${base0E}, 10%);
      $purple_5: darken(#${base0E}, 20%);

      $brown_1: lighten(#${base0F}, 20%);
      $brown_2: lighten(#${base0F}, 10%);
      $brown_3: #${base0F};
      $brown_4: darken(#${base0F}, 10%);
      $brown_5: darken(#${base0F}, 20%);

      $light_1: #ffffff;
      $light_2: #f6f5f4;
      $light_3: #deddda;
      $light_4: #c0bfbc;
      $light_5: #9a9996;
      $dark_1: #77767b;
      $dark_2: #5e5c64;
      $dark_3: #3d3846;
      $dark_4: #241f31;
      $dark_5: #000000;

      $_base_color_dark: #${base01};
      $_base_color_light: #fafafb;

      $accent_color: #${base0D};

      $accent_color: if($variant== 'light', $accent_color, mix($accent_color, $light_1, 60%));

      $destructive_bg_color: if($variant == 'light', $red_3, $red_4);
      $destructive_fg_color: $light_1;
      $destructive_color: $destructive_bg_color;

      $success_bg_color: if($variant == 'light', $green_4, $green_5);
      $success_fg_color: $light_1;
      $success_color: $success_bg_color;

      $warning_bg_color: if($variant == 'light', $yellow_5, $yellow_4); // uses darker off-palette yellow
      $warning_fg_color: transparentize(black, .2);
      $warning_color: $warning_bg_color;

      $error_bg_color: if($variant == 'light', $red_3, $red_4);
      $error_fg_color: $light_1;
      $error_color: $error_bg_color;

      $link_color: if($variant == 'light', darken($accent_color, 10%), lighten($accent_color, 20%));
      $link_visited_color: transparentize($link_color, .6);

      $background_mix_factor: if($variant == 'light', 12%, 9%); // used to boost the color of backgrounds in different variants

      $shadow_color: if($variant == 'light', rgba(0,0,0,.05), rgba(0,0,0,0.2));
      $text_shadow_color: if($variant == 'light', rgba(255,255,255,0.3), rgba(0,0,0,0.2));

      $border_opacity: if($variant == 'light', .85, .9); // change the border opacity in different variants
      $focus_border_opacity: .2;
      $focus_color: $accent_color;
      $focus_border_color: transparentize($focus_color, 0.5);

      @if $contrast == 'high' {
          $border_opacity: .5;
          $focus_border_opacity: .1;
          $shadow_color: transparent;
          $text_shadow_color: transparent;
      }

      $base_color: if($variant == 'light', $light_1, $_base_color_dark);
      $bg_color: if($variant == 'light', $_base_color_light, $dark_3);
      $fg_color: if($variant == 'light', $_base_color_dark, $light_1);

      $osd_fg_color: $light_1;
      $osd_bg_color: lighten($_base_color_dark, 5%);

      $system_base_color: $_base_color_dark;
      $system_fg_color: $_base_color_light;

      $panel_bg_color: if($variant == 'light', $_base_color_light, $dark_5);
      $panel_fg_color: if($variant == 'light', $_base_color_dark, $light_1);

      $card_bg_color: if($variant == 'light', $light_1, $bg_color);
      $card_shadow_color: if($variant == 'light', transparentize($dark_5, .97), transparent);
      $card_shadow_border_color: if($variant == 'light', transparentize($dark_5, .91), transparent);

      $borders_color: transparentize($fg_color, $border_opacity);
      $outer_borders_color: if($variant == 'light', darken($bg_color, 7%), lighten($bg_color, 5%));

      $osd_borders_color: transparentize($osd_fg_color, 0.9);
      $osd_outer_borders_color: transparentize($osd_fg_color, 0.98);

      $system_bg_color: lighten($system_base_color, 5%);
      $system_borders_color: transparentize($system_fg_color, .9);
      $system_insensitive_fg_color: mix($system_fg_color, $system_bg_color, 50%);
      $system_overlay_bg_color: mix($system_base_color, $system_fg_color, 90%); // for non-transparent items, e.g. dash

      $insensitive_fg_color: if($variant == 'light', mix($fg_color, $bg_color, 60%),  mix($fg_color, $bg_color, 50%));
      $insensitive_bg_color: mix($bg_color, $base_color, 60%);
      $insensitive_borders_color: mix($borders_color, $base_color, 60%);

      $checked_bg_color: if($variant=='light', darken($bg_color, 7%), lighten($bg_color, 7%));
      $checked_fg_color: if($variant=='light', darken($fg_color, 7%), lighten($fg_color, 7%));

      $hover_bg_color: if($variant=='light', darken($bg_color,9%), lighten($bg_color, 10%));
      $hover_fg_color: if($variant=='light', darken($fg_color,9%), lighten($fg_color, 10%));

      $active_bg_color: if($variant=='light', darken($bg_color, 11%), lighten($bg_color, 12%));
      $active_fg_color: if($variant=='light', darken($fg_color, 11%), lighten($fg_color, 12%));

      $accent_borders_color: if($variant== 'light', darken($accent_color, 20%), lighten($accent_color, 30%));
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
      rm data/theme/gnome-shell-sass/_palette.scss
      rm data/theme/gnome-shell-sass/_default-colors.scss
      rm data/theme/gnome-shell-sass/_high-contrast-colors.scss

      substituteInPlace data/theme/gnome-shell-sass/{*,**/*}.scss \
        --replace-warn '-st-accent-color' '$accent_color' \
        --replace-warn '-st-accent-fg-color' '$fg_color'

      cp ${colors} data/theme/gnome-shell-sass/_colors.scss
    '';

    buildPhase = ''
      sass data/theme/gnome-shell-dark.scss > data/theme/gnome-shell-dark.css
      sass data/theme/gnome-shell-light.scss > data/theme/gnome-shell-light.css
      glib-compile-resources --sourcedir=data/theme data/gnome-shell-theme.gresource.xml
    '';

    installPhase = ''
      mkdir -p $out/share/gnome-shell
      cp data/theme/gnome-shell-{light,dark}.css $out/share/gnome-shell
      cp data/gnome-shell-theme.gresource $out/share/gnome-shell/gnome-shell-theme.gresource
    '';
  }
