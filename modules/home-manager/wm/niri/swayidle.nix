{nixosConfig, ...}: {
  services.swayidle = {
    enable = true;

    # pgrep -x hyprlock > /dev/null || hyprlock &";
    events = [
      {
        event = "after-resume";
        command = "display-control power-on-monitors";
      }
      {
        event = "lock";
        command = "display-control power-off-monitors";
      }
      {
        event = "unlock";
        command = "display-control power-on-monitors";
      }
      {
        event = "before-sleep";
        command = "session-control lock";
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
