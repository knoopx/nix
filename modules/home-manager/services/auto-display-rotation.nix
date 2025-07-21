{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  autoDisplayRotationScript = pkgs.writeShellApplication {
    name = "auto-display-rotation";
    runtimeInputs = with pkgs; [iio-sensor-proxy mawk niri];
    text = ''
      monitor-sensor | mawk -W interactive '/Accelerometer orientation changed:/ { print $NF; fflush();}' | while read -r line
      do
        case "$line" in
          normal)
            niri msg output "DSI-1" transform normal
            ;;
          bottom-up)
            niri msg output "DSI-1" transform 180
            ;;
          right-up)
            niri msg output "DSI-1" transform 270
            ;;
          left-up)
            niri msg output "DSI-1" transform 90
            ;;
        esac
      done
    '';
  };
in {
  options.services.autoDisplayRotation.enable = mkEnableOption "Auto display rotation user service";

  config = mkIf config.services.autoDisplayRotation.enable {
    home.packages = [autoDisplayRotationScript];
    systemd.user.services.auto-display-rotation = {
      Unit = {
        Description = "Auto Display Rotation (user)";
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe autoDisplayRotationScript}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
