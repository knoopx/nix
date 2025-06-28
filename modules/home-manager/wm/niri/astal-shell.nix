{pkgs, ...}: {
  home.packages = with pkgs; [
    astal-shell
  ];

  systemd.user.services.astal-shell = {
    Unit = {
      Description = "Astal Shell";
      After = ["graphical-session.target"];
      Wants = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.astal-shell}/bin/astal-shell";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
