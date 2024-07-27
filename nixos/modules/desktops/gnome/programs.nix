{pkgs, ...}: {
  environment.gnome.excludePackages = [
    pkgs.gnome-tour
  ];

  programs = {
    dconf = {
      enable = true;
    };
    gnome-disks = {
      enable = true;
    };
  };
}
