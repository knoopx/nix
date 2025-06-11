{pkgs, ...}: {
  environment.systemPackages = [pkgs.xdg-utils pkgs.niri];
  xdg = {
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
  };

  hardware.graphics.enable = true;

  services.displayManager.sessionPackages = [pkgs.niri];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    configPackages = [pkgs.niri];
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.swaylock = {};
  programs.dconf.enable = true;
  fonts.enableDefaultPackages = true;
}
