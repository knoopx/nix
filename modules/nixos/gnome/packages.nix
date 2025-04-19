{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # gnome-boxes
    # gnome-network-displays
    sushi
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
    gnome-system-monitor
    gnome-text-editor
    libnotify
    loupe
    nautilus
    popsicle
    seahorse
    showtime
    snapshot
    xdg-desktop-portal-gnome
  ];

  environment.gnome.excludePackages = with pkgs; [
    evolution
    evolution-data-server
    gnome-initial-setup
    gnome-tour
    gnome-user-docs
    networkmanager-openconnect
    openconnect
  ];
}
