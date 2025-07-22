{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.minibook-dual-accelerometer;
in {
  options.services.minibook-dual-accelerometer = {
    enable = mkEnableOption "Chuwi MiniBook X dual accelerometer tablet-mode detection";

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ../../pkgs/minibook-dual-accelerometer.nix {};
      description = "The minibook dual accelerometer package.";
    };

    interval = mkOption {
      type = types.str;
      default = "0.5";
      description = "Interval between accelerometer polls (seconds)";
    };

    threshold = mkOption {
      type = types.str;
      default = "45";
      description = "Hinge angle threshold to enter tablet mode (degrees)";
    };

    hysteresis = mkOption {
      type = types.str;
      default = "20";
      description = "Hysteresis to add to hinge angle when leaving tablet mode (degrees)";
    };

    tiltThreshold = mkOption {
      type = types.str;
      default = "20";
      description = "Angle threshold for suppressing state changes when off-horizontal (degrees)";
    };

    jerkThreshold = mkOption {
      type = types.str;
      default = "6";
      description = "Jerk (rate of change of acceleration) threshold for suppressing state changes while moving erratically (m/s^3)";
    };

    extraArguments = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additional arguments to pass to the angle-sensor service";
    };
  };

  config = mkIf cfg.enable {
    # Install the package
    environment.systemPackages = [cfg.package];

    # Add the kernel module to boot.extraModulePackages
    boot.extraModulePackages = [(pkgs.callPackage ../../pkgs/chuwi-ltsm-hack-module.nix {kernel = config.boot.kernelPackages.kernel;})];

    # Load the kernel modules
    boot.kernelModules = ["chuwi-ltsm-hack" "mxc4005" "intel-hid"];

    # Ensure chuwi-ltsm-hack module is loaded after DKMS builds it
    boot.extraModprobeConfig = ''
      options intel-hid force_tablet_mode=Y
    '';

    # udev rules for accelerometer detection and configuration
    services.udev.extraRules = let
      mxc4005 = pkgs.writeShellScriptBin "mxc4005" ''
        device_path=$(dirname $(grep Synopsys /sys/bus/i2c/devices/i2c-*/name 2>/dev/null | head -n1) | head -n1)/new_device
        echo mxc4005 0x15 > "$device_path"
      '';
    in ''
      SUBSYSTEM=="iio", KERNEL=="iio*", SUBSYSTEMS=="i2c", \
              DEVPATH=="*/i2c-*/i2c-MDA6655:00/iio:device0", \
              ENV{ACCEL_LOCATION}="display", \
              ENV{ACCEL_MOUNT_MATRIX}="1,0,0;0,1,0;0,0,1", \
              RUN+="${lib.getExe mxc4005}", \
              ENV{SYSTEMD_WANTS}="angle-sensor.service"

      SUBSYSTEM=="iio", KERNEL=="iio*", SUBSYSTEMS=="i2c", \
              DEVPATH=="*/i2c-*/*-0015/iio:device1", \
              ENV{ACCEL_LOCATION}="base", \
              ENV{ACCEL_MOUNT_MATRIX}="1,0,0;0,1,0;0,0,1", \
              RUN{builtin}+="kmod load chuwi-ltsm-hack", \
              ENV{SYSTEMD_WANTS}="angle-sensor.service"
    '';

    # systemd service for angle sensor
    systemd.services.angle-sensor = {
      description = "Chuwi MiniBook angle sensor daemon";
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];

      environment = {
        INTERVAL = cfg.interval;
        THRESHOLD = cfg.threshold;
        HYSTERESIS = cfg.hysteresis;
        TILT_THRESHOLD = cfg.tiltThreshold;
        JERK_THRESHOLD = cfg.jerkThreshold;
        COMMAND = "${cfg.package}/bin/chuwi-tablet-control";
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/angle-sensor --interval $INTERVAL --threshold $THRESHOLD --hysteresis $HYSTERESIS --tilt-threshold $TILT_THRESHOLD --jerk-threshold $JERK_THRESHOLD $COMMAND ${concatStringsSep " " cfg.extraArguments}";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };
}
