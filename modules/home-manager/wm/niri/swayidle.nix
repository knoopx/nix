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
    events = [
      {
        event = "after-resume";
        command = "${lib.getExe pkgs.display-control} power-on-monitors";
      }
      {
        event = "lock";
        command = "${lib.getExe pkgs.display-control} power-off-monitors";
      }
      {
        event = "unlock";
        command = "${lib.getExe pkgs.display-control} power-on-monitors";
      }
      {
        event = "before-sleep";
        command = "${lib.getExe pkgs.session-control} lock";
      }
    ];
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
