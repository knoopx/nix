{
  pkgs,
  config,
  defaults,
  neuwaita,
  ...
}: let
  reloadScript = ''
    if [[ -x "$(command -v gnome-extensions)" ]]; then
      gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
      gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    fi
  '';
in {
  stylix.targets.gnome.enable = false;
  stylix.targets.glance.enable = false;

  home.packages = [
    pkgs.adwaita-icon-theme
    (pkgs.theming.mkMoreWaitaTheme defaults.colorScheme.palette)
  ];

  gtk = {
    # iconTheme = {
    #   name = "MoreWaita";
    #   package = pkgs.theming.mkMoreWaitaTheme defaults.colorScheme.palette;
    # };
    iconTheme = {
      name = "Neuwaita";
      package = pkgs.stdenvNoCC.mkDerivation {
        name = "Neuwaita";
        src = neuwaita;

        installPhase = ''
          mkdir -p $out/share/icons/Neuwaita/{scalable,symbolic}/{apps,devices,legacy,mimetypes,places,status}
          cp -r scalable/* $out/share/icons/Neuwaita/scalable/
          cp -r index.theme $out/share/icons/Neuwaita/index.theme
          substituteInPlace $out/share/icons/Neuwaita/index.theme --replace-fail "Inherits=Adwaita, hicolor, breeze" "Inherits=MoreWaita,Adwaita,hicolor,breeze"
        '';
      };
    };
  };

  xdg.dataFile."themes/Custom/gnome-shell/gnome-shell-dark.css" = {
    source = "${pkgs.custom-gnome-shell-theme}/share/gnome-shell/gnome-shell-dark.css";
    onChange = reloadScript;
  };

  xdg.dataFile."themes/Custom/gnome-shell/gnome-shell-light.css" = {
    source = "${pkgs.custom-gnome-shell-theme}/share/gnome-shell/gnome-shell-light.css";
    onChange = reloadScript;
  };

  # home.file = {
  #   ".local/share/icons/${config.gtk.iconTheme.name}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.path}/share/icons/${config.gtk.iconTheme.name}";
  #   ".local/share/themes/${config.gtk.theme.name}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.path}/share/themes/${config.gtk.theme.name}";

  #   # ".local/share/flatpak/overrides/global".text = ''
  #   #   [Context]
  #   #   filesystems=home;xdg-data/themes:ro;xdg-data/icons:ro;xdg-config/gtkrc:ro;xdg-config/gtkrc-2.0:ro;xdg-config/gtk-2.0:ro;xdg-config/gtk-3.0:ro;xdg-config/gtk-4.0:ro;/nix/store:ro
  #   #   sockets=fallback-x11;wayland;x11
  #   #   devices=dri

  #   #   [Environment]
  #   #   GTK_THEME=${config.gtk.theme.name}
  #   # '';
  # };

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme".name = "Custom";

    "org/gnome/desktop/background" = {
      picture-options = "zoom";
      picture-uri = "file://${config.stylix.image}";
      picture-uri-dark = "file://${config.stylix.image}";
    };

    "org/gnome/desktop/interface" = let
      inherit (config.stylix.fonts) sansSerif serif monospace;
      fontSize = toString config.stylix.fonts.sizes.applications;
      documentFontSize = toString (config.stylix.fonts.sizes.applications - 1);
    in {
      cursor-theme = config.stylix.cursor.name;
      color-scheme = "prefer-dark";
      font-name = "${sansSerif.name} ${fontSize}";
      document-font-name = "${serif.name}  ${documentFontSize}";
      monospace-font-name = "${monospace.name} ${fontSize}";
    };
  };
}
