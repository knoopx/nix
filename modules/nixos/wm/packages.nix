{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnome-control-center
    xwayland-satellite
    code-nautilus
  ];
}
