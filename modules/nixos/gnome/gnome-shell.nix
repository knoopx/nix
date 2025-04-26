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
        patches =
          oldAttrs.patches
          ++ [
            (pkgs.fetchurl
              {
                url = "https://raw.githubusercontent.com/danth/stylix/refs/heads/master/modules/gnome/shell_remove_dark_mode.patch";
                sha256 = "sha256-MCI8zs5ru2tqLwiqeSZTp3SbkO+PV6ZVivW5y5Ck6X4=";
              })
          ];
        postFixup =
          (oldAttrs.postFixup or "")
          + ''
            cp ${theme}/share/gnome-shell/gnome-shell-theme.gresource $out/share/gnome-shell/gnome-shell-theme.gresource
          '';
      });
    })
  ];
}
