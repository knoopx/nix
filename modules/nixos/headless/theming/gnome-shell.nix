{defaults, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      gnome-shell = prev.gnome-shell.overrideAttrs (oldAttrs: {
        preConfigure =
          # sed -i '1s/^/$selected_bg_color: if($variant == 'light', $blue_4, $blue_3); $selected_fg_color: $light_1;\n/' data/theme/gnome-shell-sass/_default-colors.scss
          (oldAttrs.preConfigure or "")
          + ''
            sed -i '1s/^/$selected_fg_color: #${defaults.colorScheme.palette.base07}; $selected_bg_color: #${defaults.colorScheme.palette.base07};\n/' \
              data/theme/gnome-shell-sass/_default-colors.scss

            substituteInPlace data/theme/gnome-shell-sass/{*,**/*}.scss \
              --replace-warn '-st-accent-color' '$selected_bg_color' \
              --replace-warn '-st-accent-fg-color' '$selected_fg_color'
          '';
      });
    })
  ];
}
