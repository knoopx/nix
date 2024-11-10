{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libnotify
    gnome-monitor-config
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-initial-setup
    gnome-user-docs
    openconnect
    networkmanager-openconnect
    evolution
    evolution-data-server
  ];
}
