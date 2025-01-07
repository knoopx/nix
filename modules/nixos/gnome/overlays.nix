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
    })
  ];
}
