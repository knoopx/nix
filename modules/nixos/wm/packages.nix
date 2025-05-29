{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    gnome-control-center
  ];
}
