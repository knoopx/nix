{config, ...} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in {
  imports =
    [
      ./boot.nix
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  system.stateVersion = "25.11";

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

  networking.hostName = "minibookx";
  nix.settings.system-features = [
  ];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  defaults.display.width = 1920;
  defaults.display.height = 1200;
  defaults.display.idleTimeout = 60; # 1 minute for battery conservation
  defaults.display.defaultColumnWidthPercent = 1.0;
  defaults.display.columnWidthPercentPresets = [0.5 0.75];

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;
}
