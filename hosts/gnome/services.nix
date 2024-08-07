{
  pkgs,
  defaults,
  ...
}: {
  services = {
    flatpak.enable = true;
    gvfs.enable = true;

    xserver = {
      enable = true;
      xkb.layout = defaults.keyMap;
      desktopManager.gnome.enable = true;
      excludePackages = [pkgs.xterm];
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          autoSuspend = false;
        };
      };
    };

    displayManager = {
      sessionPackages = [pkgs.gnome.gnome-session.sessions];
    };

    gnome = {
      core-utilities.enable = false;
      gnome-keyring.enable = true;
    };
  };
}
