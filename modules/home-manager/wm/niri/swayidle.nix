{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "after-resume";
        command = "${lib.getExe pkgs.niri} msg action power-on-monitors";
      }
    ];
    timeouts = [
      {
        timeout = nixosConfig.defaults.display.idleTimeout;
        command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
      }
    ];
  };
}
