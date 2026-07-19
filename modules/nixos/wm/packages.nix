{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    astal-shell # Astal desktop shell for Wayland
    gnome-control-center # GNOME desktop configuration utilities
    gnome-bluetooth # Bluetooth management for GNOME
    networkmanager # Network configuration and management
    wl-clipboard # Wayland clipboard tools (wl-copy, wl-paste)
    wl-kbptr # Control mouse pointer with keyboard (Wayland)
    wshowkeys # Wayland key/mouse event viewer
    xwayland-satellite # Xwayland outside your Wayland compositor
  ];
}
