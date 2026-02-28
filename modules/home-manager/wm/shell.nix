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

  systemd.user.services.window-control = {
    Unit = {
      Description = "Window control daemon";
      After = ["niri.service"];
    };
    Service = {
      ExecStart = "${pkgs.window-control}/bin/window-control daemon";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
