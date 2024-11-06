{
  pkgs,
  config,
  ...
}: {
  gtk = {
    iconTheme = {
      # package = pkgs.dracula-icon-theme;
      # name = "Dracula";
      package = pkgs.morewaita-icon-theme;
      name = "MoreWaita";
    };
  };

  home.file = {
    ".local/share/icons/${config.gtk.iconTheme.name}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.path}/share/icons/${config.gtk.iconTheme.name}";
    ".local/share/themes/${config.gtk.theme.name}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.path}/share/themes/${config.gtk.theme.name}";

    ".local/share/flatpak/overrides/global".text = ''
      [Context]
      filesystems=home;xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;/nix/store:ro
      sockets=fallback-x11;wayland;x11
      devices=dri

      [Environment]
      GTK_THEME=${config.gtk.theme.name}
    '';
  };
}
