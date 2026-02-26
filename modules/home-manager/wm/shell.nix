{pkgs, ...}: {
  home.packages = [
    pkgs.brightness-control
    pkgs.browser
    pkgs.display-control
    pkgs.editor
    pkgs.file-manager
    pkgs.image-viewer
    pkgs.media-control
    pkgs.session-control
    pkgs.tablet-mode-control
    pkgs.terminal
    pkgs.window-control
    pkgs.volume-control
  ];
}
