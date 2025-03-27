{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # gnome-boxes
    amberol
    authenticator
    baobab
    decibels
    drawing
    drum-machine
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
    gnome-text-editor
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
