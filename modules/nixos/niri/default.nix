{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    niri-unstable
  ];
}
