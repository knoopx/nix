{
  pkgs,
  defaults,
  ...
}: let
  gtk-apps = with pkgs; [
    # alpaca
    # firefox
    # plasticity
    # livecaptions
    amberol
    authenticator
    # blender
    commit
    czkawka
    drawing
    eog
    evince
    fclones-gui
    file-roller
    gitg
    gnome-calendar
    gnome-control-center
    gnome-system-monitor
    google-chrome
    mpv
    nautilus
    nicotine-plus
    seahorse
    transmission_4-gtk
    vial
    xdg-desktop-portal-gnome
    # zed-editor
    rclone
    f3d
  ];
in {
  home = {
    packages = gtk-apps ++ defaults.gnome.extensions;
  };
}
