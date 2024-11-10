{pkgs, ...}: {
  programs = {
    dconf = {
      enable = true;
    };
    gnome-disks = {
      enable = true;
    };
  };
}
