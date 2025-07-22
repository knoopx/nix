{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hardware.chuwi-minibook-x.autoDisplayRotation;
in {
  options.hardware.chuwi-minibook-x.autoDisplayRotation = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable auto display rotation.";
        };
        commands = lib.mkOption {
          type = lib.types.submodule {
            options = {
              normal = lib.mkOption {
                type = lib.types.str;
                default = ''niri msg output "DSI-1" transform normal'';
                description = "Shell command to run when orientation is normal.";
              };
              bottomUp = lib.mkOption {
                type = lib.types.str;
                default = ''niri msg output "DSI-1" transform 180'';
                description = "Shell command to run when orientation is bottom-up (inverted).";
              };
              rightUp = lib.mkOption {
                type = lib.types.str;
                default = ''niri msg output "DSI-1" transform 270'';
                description = "Shell command to run when orientation is right-up (rotated right).";
              };
              leftUp = lib.mkOption {
                type = lib.types.str;
                default = ''niri msg output "DSI-1" transform 90'';
                description = "Shell command to run when orientation is left-up (rotated left).";
              };
            };
          };
          default = {
            normal = ''niri msg output "DSI-1" transform normal'';
            bottomUp = ''niri msg output "DSI-1" transform 180'';
            rightUp = ''niri msg output "DSI-1" transform 270'';
            leftUp = ''niri msg output "DSI-1" transform 90'';
          };
          description = ''
            Commands to execute for each detected orientation. Each value should be a shell command string.
            Defaults match the current niri usage for DSI-1 output.
          '';
          example = {
            normal = ''echo "normal"'';
            bottomUp = ''echo "bottom-up"'';
            rightUp = ''echo "right-up"'';
            leftUp = ''echo "left-up"'';
          };
        };
      };
    };
    default = {
      enable = true;
      commands = {
        normal = ''niri msg output "DSI-1" transform normal'';
        bottomUp = ''niri msg output "DSI-1" transform 180'';
        rightUp = ''niri msg output "DSI-1" transform 270'';
        leftUp = ''niri msg output "DSI-1" transform 90'';
      };
    };
    description = "Auto display rotation configuration for Chuwi Minibook X.";
  };

  config = lib.mkIf cfg.enable (
    let
      autoDisplayRotationScript = pkgs.writeShellApplication {
        name = "auto-display-rotation";
        runtimeInputs = with pkgs; [iio-sensor-proxy mawk niri];
        text = ''
          monitor-sensor | mawk -W interactive '/Accelerometer orientation changed:/ { print $NF; fflush();}' | while read -r line
          do
            case "$line" in
              normal)
                ${cfg.commands.normal}
                ;;
              bottom-up)
                ${cfg.commands.bottomUp}
                ;;
              right-up)
                ${cfg.commands.rightUp}
                ;;
              left-up)
                ${cfg.commands.leftUp}
                ;;
            esac
          done
        '';
      };
    in {
      home.packages = [autoDisplayRotationScript];
      systemd.user.services.auto-display-rotation = {
        Unit = {
          Description = "Auto Display Rotation";
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
    }
  );
}
