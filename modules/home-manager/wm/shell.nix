{
  nixosConfig,
  pkgs,
  ...
}: let
  apps = nixosConfig.defaults.apps;
in {
  home.packages = [
    pkgs.brightness-control
    apps.browser.package
    pkgs.display-control
    apps.editor.package
    apps.fileManager.package
    apps.imageViewer.package
    pkgs.media-control
    pkgs.session-control
    pkgs.tablet-mode-control
    apps.terminal.package
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
