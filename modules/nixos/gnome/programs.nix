{pkgs, ...}: {
  environment.gnome.excludePackages = [
    pkgs.gnome-tour
    pkgs.gnome-initial-setup
    pkgs.gnome-user-docs
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
