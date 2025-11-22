{pkgs, ...}: {
  programs.niri.enable = true;
  environment.systemPackages = [
    pkgs.xdg-utils
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-gtk
  ];

  xdg = {
    portal.enable = true;
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
    portal = {
      config.niri = {
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
        "org.freedesktop.impl.portal.OpenURI" = ["gtk"];
      };
    };
  };

  services.displayManager.sessionPackages = [pkgs.niri];
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  programs.dconf.enable = true;
  fonts.enableDefaultPackages = true;
}
