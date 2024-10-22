{
  pkgs,
  defaults,
  ...
}: let
  gtk-apps = with pkgs; [
    gnome-control-center
    nautilus
    xdg-desktop-portal-gnome
    # gnome-system-monitor
    # amberol
    # authenticator
    # commit
    # czkawka
    # drawing
    # eog
    # evince
    # f3d
    # fclones-gui
    # file-roller
    # gitg
    # gnome-calendar
    # mpv
    # nicotine-plus
    # rclone
    # seahorse
    # transmission_4-gtk
    # vial
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
