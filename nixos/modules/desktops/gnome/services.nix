{pkgs, ...}: {
  services = {
    # flatpak.enable = true;
    gvfs.enable = true;

    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = [pkgs.xterm];
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
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

    fractalart = {
      enable = true;
    };
  };
}
