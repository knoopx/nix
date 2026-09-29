{
  lib,
  pkgs,
  nixosConfig,
  ...
}: let
  dc = lib.getExe' pkgs.display-control "display-control";
  sc = lib.getExe' pkgs.session-control "session-control";
  onBattery = "! ${pkgs.upower}/bin/upower --dump | grep -q 'online.*yes'";
  onAC = "${pkgs.upower}/bin/upower --dump | grep -q 'online.*yes'";
  idleTimeout = nixosConfig.defaults.display.idleTimeout;
  idleTimeoutAC = nixosConfig.defaults.display.idleTimeoutAC;
  lockEnabled = nixosConfig.defaults.display.lockEnabled;
  beforeSleep = if lockEnabled then "${sc} lock" else "${dc} power-off-monitors";
in {
  services.swayidle = {
    enable = true;

    events = {
      after-resume = "${dc} power-on-monitors";
      lock = "${dc} power-off-monitors";
      unlock = "${dc} power-on-monitors";
      before-sleep = beforeSleep;
    };
    timeouts =
      (lib.optionals (idleTimeoutAC != null) (
        [
          {
            timeout = idleTimeout;
            command = "${onBattery} && ${dc} power-off-monitors";
          }
          {
            timeout = idleTimeoutAC;
            command = "${onAC} && ${dc} power-off-monitors";
          }
        ]
        ++ lib.optionals lockEnabled [
          {
            timeout = idleTimeout + 5;
            command = "${onBattery} && ${sc} lock";
          }
          {
            timeout = idleTimeoutAC + 5;
            command = "${onAC} && ${sc} lock";
          }
        ]))
      ++ (lib.optionals (idleTimeoutAC == null) (
        [
          {
            timeout = idleTimeout;
            command = "${dc} power-off-monitors";
          }
        ]
        ++ lib.optionals lockEnabled [
          {
            timeout = idleTimeout + 5;
            command = "${sc} lock";
          }
        ]));
  };
}
