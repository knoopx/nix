{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  services.swayidle = {
    enable = true;

    # pgrep -x hyprlock > /dev/null || hyprlock &";
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
      {
        timeout = nixosConfig.defaults.display.idleTimeout + 5;
        command = "${lib.getExe pkgs.hyprlock}";
      }
    ];
  };
}
