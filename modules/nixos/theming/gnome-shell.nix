{
  pkgs,
  config,
  defaults,
  ...
}: let
  theme = pkgs.theming.mkGnomeShellTheme defaults.colorScheme.palette;
in {
  stylix.targets.gnome.enable = false;
  environment.systemPackages = [config.stylix.cursor.package];

  nixpkgs.overlays = [
    (self: super: {custom-gnome-shell-theme = theme;})
    (self: super: {
      gnome-shell = super.gnome-shell.overrideAttrs (oldAttrs: {
        postFixup =
          (oldAttrs.postFixup or "")
          + ''
            cp ${theme}/share/gnome-shell/gnome-shell-theme.gresource $out/share/gnome-shell/gnome-shell-theme.gresource
          '';
      });
    })
  ];
}
