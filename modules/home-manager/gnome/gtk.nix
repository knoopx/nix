{
  pkgs,
  config,
  ...
}: let
  adwaita-colors = pkgs.fetchFromGitHub {
    owner = "dpejoh";
    repo = "Adwaita-colors";
    rev = "v2.4.1";
    sha256 = "sha256-M5dFb759sXfpD9/gQVF3sngyW4WdSgy4usInds9VIWk=";
  };
in {
  gtk = {
    iconTheme = {
      package = pkgs.morewaita-icon-theme.overrideAttrs (prev: {
        postInstall = ''
          cp -r ${adwaita-colors}/Adwaita-blue/* $out/share/icons/MoreWaita

          substituteInPlace $out/share/icons/MoreWaita/scalable/**/{folder*,user-*,inode-directory}.svg \
            --replace-warn '#438de6' '#181825' \
            --replace-warn '#62a0ea' '#1e1e2e' \
            --replace-warn '#a4caee' '#313244' \
            --replace-warn '#afd4ff' '#45475a' \
            --replace-warn '#c0d5ea' '#585b70' \
            --replace-warn '#1a5fb4' '#181825' \
            --replace-warn '#3584e4' '#1e1e2e' \
            --replace-warn '#99c1f1' '#313244' \
            --replace-warn '#c3e5e7' '#585b70'
        '';
      });
      name = "MoreWaita";
    };
  };

  home.file = {
    ".local/share/icons/${config.gtk.iconTheme.name}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.path}/share/icons/${config.gtk.iconTheme.name}";
    ".local/share/themes/${config.gtk.theme.name}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.path}/share/themes/${config.gtk.theme.name}";

    # ".local/share/flatpak/overrides/global".text = ''
    #   [Context]
    #   filesystems=home;xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;/nix/store:ro
    #   sockets=fallback-x11;wayland;x11
    #   devices=dri

    #   [Environment]
    #   GTK_THEME=${config.gtk.theme.name}
    # '';
  };
}
