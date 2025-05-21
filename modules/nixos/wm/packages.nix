{pkgs, ...}: {
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    niri
    gnome-control-center
  ];
}
