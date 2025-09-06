{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnome-control-center
    gnome-bluetooth
    networkmanager
    xwayland-satellite
    code-nautilus
  ];
}
