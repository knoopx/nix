{
  pkgs,
  defaults,
  ...
}: let
  gtk-apps = with pkgs; [
    amberol
    authenticator
    commit
    czkawka
    drawing
    eog
    evince
    f3d
    fclones-gui
    file-roller
    gitg
    gnome-calendar
    gnome-control-center
    gnome-system-monitor
    mpv
    nautilus
    nicotine-plus
    rclone
    seahorse
    transmission_4-gtk
    vial
    xdg-desktop-portal-gnome
    zed-editor
    # alpaca
    # blender
    # firefox
    # google-chrome
    # livecaptions
    # plasticity
  ];
in {
  home = {
    packages = gtk-apps ++ defaults.gnome.extensions;
  };
}
