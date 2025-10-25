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
        command = "display-control power-on-monitors";
      }
    ];
    timeouts = [
      {
        timeout = nixosConfig.defaults.display.idleTimeout;
        command = "display-control power-off-monitors";
      }
      {
        timeout = nixosConfig.defaults.display.idleTimeout + 5;
        command = "session-control lock";
      }
    ];
  };
}
