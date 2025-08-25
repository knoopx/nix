{pkgs, ...}: {
  home.packages = with pkgs; [
    amberol
    baobab
    czkawka
    dconf-editor
    drawing
    eog
    evince
    file-roller
    geary
    gitg
    gnome-calendar
    gnome-disk-utility
    gnome-secrets
    gnome-text-editor
    gnome-weather
    loupe
    mission-center
    nautilus
    onlyoffice-bin
    pinta
    plexamp
    seahorse
    sushi
  ];
}
