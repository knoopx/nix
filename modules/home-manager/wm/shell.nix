{pkgs, ...}: {
  home.packages = [
    pkgs.brightness-control
    pkgs.display-control
    pkgs.media-control
    pkgs.session-control
    pkgs.volume-control
  ];
}
