{nixos-hardware}: {
  config,
  lib,
  ...
}:
with lib; {
  imports = [
    nixos-hardware.nixosModules.chuwi-minibook-x
    ./minibook-dual-accelerometer.nix
  ];

  options.hardware.chuwi-minibook-x = {
    enable = lib.mkEnableOption "Enable Chuwi MiniBook X specific configurations";
    autoDisplayRotation = {
      enable =
        (mkEnableOption "Enable automatic display rotation based on accelerometer data")
        // {
          default = true;
        };
    };
  };

  config = let
    cfg = config.hardware.chuwi-minibook-x;
  in
    lib.mkIf cfg.enable {
      hardware.sensor.iio = {
        enable = true;
      };

      systemd.services.iio-sensor-proxy = {
        wantedBy = ["multi-user.target"];
        after = ["graphical.target"];
      };

      services.minibook-dual-accelerometer = {
        enable = true;

        interval = "0.3"; # Slightly faster polling for better UX
        threshold = "50"; # Adjust threshold for your preference
        hysteresis = "15"; # Reduce hysteresis for quicker mode switching
        tiltThreshold = "15"; # More sensitive to orientation changes
      };
    };
}
