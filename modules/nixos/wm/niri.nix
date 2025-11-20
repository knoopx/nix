{pkgs, ...}: {
  programs.niri.enable = true;
  environment.systemPackages = [pkgs.xdg-utils];
  xdg = {
    autostart.enable = true;
    menus.enable = true;
    mime.enable = true;
    icons.enable = true;
  };

  hardware.graphics.enable = true;

  services.displayManager.sessionPackages = [pkgs.niri-unstable];
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.swaylock = {};
  programs.dconf.enable = true;
  fonts.enableDefaultPackages = true;
}
