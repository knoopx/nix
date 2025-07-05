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

    package = mkPackageOption pkgs "minibook-dual-accelerometer" {};

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
    boot.extraModulePackages = [(pkgs.callPackage ../../../pkgs/chuwi-ltsm-hack-module.nix {kernel = config.boot.kernelPackages.kernel;})];

    # Load the kernel modules
    boot.kernelModules = ["chuwi-ltsm-hack" "mxc4005" "intel-hid"];

    # Ensure chuwi-ltsm-hack module is loaded after DKMS builds it
    boot.extraModprobeConfig = ''
      # Allow intel-hid module to recognize tablet-mode switch events on MiniBook X
      options intel-hid force_tablet_mode=Y
    '';

    # udev rules for accelerometer detection and configuration
    services.udev.extraRules = ''
      # The dual accelerometers on the MiniBook X have the same modalias, so hwdb
      # can't tell them apart. Differentiate them using the devpath and set
      # ACCEL_LOCATION as appropriate.

      SUBSYSTEM=="iio", KERNEL=="iio*", SUBSYSTEMS=="i2c", \
          DEVPATH=="*/i2c-1/i2c-MDA6655:00/iio:device0", \
          ENV{ACCEL_LOCATION}="display", \
          ENV{ACCEL_MOUNT_MATRIX}="0,-1,0;1,0,0;0,0,1", \
          RUN+="/bin/sh -c 'echo mxc4005 0x15 > /sys/bus/i2c/devices/i2c-0/new_device'", \
          ENV{SYSTEMD_WANTS}="angle-sensor.service"

      SUBSYSTEM=="iio", KERNEL=="iio*", SUBSYSTEMS=="i2c", \
          DEVPATH=="*/i2c-0/0-0015/iio:device1", \
          ENV{ACCEL_LOCATION}="base", \
          ENV{ACCEL_MOUNT_MATRIX}="0,-1,0;1,0,0;0,0,1", \
          RUN{builtin}+="kmod load chuwi-ltsm-hack", \
          ENV{SYSTEMD_WANTS}="angle-sensor.service"
    '';

    # systemd service for angle sensor
    systemd.services.angle-sensor = {
      description = "Chuwi MiniBook rotation daemon";
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

        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = false; # Need access to sysfs
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Allow access to sysfs for tablet mode control
        ReadWritePaths = [
          "/sys/devices/platform/MDA6655:00"
          "/sys/bus/acpi/devices/MDA6655:00"
        ];

        # Allow access to IIO devices
        SupplementaryGroups = ["input"];

        # Resource limits
        MemoryMax = "50M";
        TasksMax = "10";
      };
    };

    # Ensure required groups exist
    users.groups.input = {};

    # Hardware detection warning
    warnings = mkIf (!config.services.minibook-dual-accelerometer.enable) [
      ''
        The minibook-dual-accelerometer service is designed specifically for the Chuwi MiniBook X.
        It may not work correctly on other hardware and could potentially cause issues.
        Make sure you're running this on a Chuwi MiniBook X before enabling.
      ''
    ];

    # Add firmware support for some common MiniBook X issues
    hardware.firmware = [pkgs.linux-firmware];
  };
}
