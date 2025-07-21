{...}: {
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "powersave";
      turbo = "never";
    };
  };

  # Enable dual accelerometer tablet-mode detection for MiniBook X
  # This service uses the chuwi-ltsm-hack kernel module to detect orientation
  # and automatically switch between laptop and tablet modes
  services.minibook-dual-accelerometer = {
    enable = true;
    # Fine-tune for better responsiveness on battery
    interval = "0.3"; # Slightly faster polling for better UX
    threshold = "50"; # Adjust threshold for your preference
    hysteresis = "15"; # Reduce hysteresis for quicker mode switching
    tiltThreshold = "15"; # More sensitive to orientation changes
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["0001:0001"];
        settings = {
          main = {
            leftmeta = "leftalt";
            leftalt = "overload(meta, M-.)";
          };
        };
      };
    };
  };
}
