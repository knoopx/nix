{
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
in {
  services.swayidle = {
    enable = true;

    # pgrep -x hyprlock > /dev/null || hyprlock &";
    events = {
      after-resume = "${lib.getExe pkgs.display-control} power-on-monitors";
      lock = "${lib.getExe pkgs.display-control} power-off-monitors";
      unlock = "${lib.getExe pkgs.display-control} power-on-monitors";
      before-sleep = "${lib.getExe pkgs.session-control} lock";
    };
    timeouts = [
      {
        timeout = nixosConfig.defaults.display.idleTimeout;
        command = "${lib.getExe pkgs.display-control} power-off-monitors";
      }
      {
        timeout = nixosConfig.defaults.display.idleTimeout + 5;
        command = "${lib.getExe pkgs.session-control} lock";
      }
    ];
  };
}
