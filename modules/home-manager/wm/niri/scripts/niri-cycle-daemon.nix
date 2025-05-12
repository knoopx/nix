{
  pkgs,
  lib,
  ...
}: let
  niri-cycle-daemon = pkgs.writeShellScriptBin "niri-cycle-daemon" ''
    exec ${pkgs.python3}/bin/python3 ${./niri-cycle-daemon.py}
  '';
in {
  systemd.user.services.niri-cycle-daemon = {
    Unit = {
      Description = "Niri window tracker";
      After = ["graphical-session.target"];
      BindsTo = "niri.service";
    };

    Service = {
      ExecStart = "${lib.getExe niri-cycle-daemon}";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
