{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    amberol
    # gnome-boxes
    # gnome-system-monitor
    authenticator
    baobab
    decibels
    drawing
    eog
    evince
    gnome-calendar
    gnome-control-center
    gnome-monitor-config
    gnome-secrets
    gnome-system-monitor
    libnotify
    loupe
    nautilus
    seahorse
    showtime
    snapshot
    xdg-desktop-portal-gnome
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
