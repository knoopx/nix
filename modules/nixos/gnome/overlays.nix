{
  pkgs,
  # colors,
  # templates,
  ...
}: let
  # colorsScss = colors {
  #   template = ./colors.mustache;
  #   extension = "scss";
  # };
  # theme = pkgs.stdenv.mkDerivation {
  #   # name = "${colors.slug}-gnome-shell-theme";
  #   nativeBuildInputs = with pkgs; [sass glib.dev];
  #   buildPhase = ''
  #     gresource extract $out/share/gnome-shell/gnome-shell-theme.gresource
  #   '';
  #   installPhase = ''
  #     mkdir -p $out/share/gnome-shell
  #     mv data/gnome-shell-theme.gresource $out/share/gnome-shell/gnome-shell-theme.gresource
  #   '';
  # };
in {
  nixpkgs.overlays = [
    (final: prev: {
      htop = prev.htop.overrideAttrs (origAttrs: {
        postInstall = "rm $out/share/applications/htop.desktop";
      });

      btop = prev.btop.overrideAttrs (origAttrs: {
        postInstall = "rm $out/share/applications/btop.desktop";
      });

      micro = prev.micro.overrideAttrs (origAttrs: {
        postInstall =
          origAttrs.postInstall + "rm $out/share/applications/micro.desktop";
      });

      gnome-shell = prev.gnome-shell.overrideAttrs (oldAttrs: {
        postFixup =
          (oldAttrs.postFixup or "")
          + ''
            # gresource extract data/gnome-shell-theme.gresource /org/gnome/shell/theme/gnome-shell.css | cat
            # # find
            # exit 1
            # $out/share/gnome-shell/gnome-shell-theme.gresource
            # echo "LOOOOOOOOOOOOOOOOOOOOOL"
            # cp $theme}/share/gnome-shell/gnome-shell-theme.gresource \
            #   $out/share/gnome-shell/gnome-shell-theme.gresource
          '';

        # preConfigure =
        #   (oldAttrs.preConfigure or "")
        #   + ''
        #     sed -i '1s/^/$selected_bg_color: if($variant == 'light', $blue_4, $blue_3); $selected_fg_color: $light_1;\n/' data/theme/gnome-shell-sass/_default-colors.scss
        #     substituteInPlace data/theme/gnome-shell-sass/{*,**/*}.scss \
        #       --replace '-st-accent-color' '$selected_bg_color' \
        #       --replace '-st-accent-fg-color' '$selected_fg_color'
        #   '';
      });
    })
  ];
}
