{ lib, pkgs, ... }: {
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  environment.systemPackages = [
    pkgs.xdg-utils # Desktop integration tools for applications
    pkgs.xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
    pkgs.xdg-desktop-portal-gnome # xdg-desktop-portal backend for GNOME
    pkgs.xdg-desktop-portal-gtk # Desktop integration portals for sandboxed apps
  ];

  xdg = {
    portal.enable = true;
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
    portal = {
      config.niri = {
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
      };
    };
  };

  services.displayManager = {
    defaultSession = lib.mkDefault "niri";
    sessionPackages = [
      pkgs.niri # Scrollable-tiling Wayland compositor
    ];
  };
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;
  fonts.enableDefaultPackages = true;
}
