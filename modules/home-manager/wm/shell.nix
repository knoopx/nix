{
  nixosConfig,
  pkgs,
  ...
}: let
  apps = nixosConfig.defaults.apps;
in {
  home.packages = [
    pkgs.brightness-control # Screen brightness control
    apps.browser.package
    pkgs.display-control # Power monitors on/off
    apps.editor.package
    apps.fileManager.package
    apps.imageViewer.package
    pkgs.media-control # Media playback controls
    pkgs.session-control # Session lock, logout, suspend, etc.
    pkgs.tablet-mode-control # Enable/disable screen keyboard
    apps.terminal.package
    pkgs.window-control # Window button theming
    pkgs.volume-control # Audio volume control
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

  systemd.user.services.inbox = {
    Unit = {
      Description = "Inbox cache daemon";
    };
    Service = {
      ExecStart = "${pkgs.inbox}/bin/inbox daemon";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  systemd.user.services.events = {
    Unit = {
      Description = "Events cache daemon";
    };
    Service = {
      ExecStart = "${pkgs.events}/bin/events daemon";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
