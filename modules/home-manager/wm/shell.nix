{pkgs, ...}: {
  home.packages = [
    pkgs.brightness-control
    pkgs.display-control
    pkgs.media-control
    pkgs.session-control
    pkgs.tablet-mode-control
    pkgs.window-control
    pkgs.volume-control
  ];
}
