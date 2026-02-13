{
  lib,
  config,
  pkgs,
  ...
} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports = listNixModulesRecusive ../../modules/nixos;

  networking.hostName = "kos";
  networking.hostId = "67faa5a0";

  nixpkgs.hostPlatform = system;

  system.stateVersion = "25.05";

  # Boot configuration
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # Display manager with greeter
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
      initial_session = {
        command = "niri-session";
        user = config.defaults.username;
      };
    };
  };

  # Disable btrfs scrub (not using btrfs)
  services.btrfs.autoScrub.enable = lib.mkForce false;

  # Home manager configuration
  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;

  # Disko disk configuration
  # Uses $DISKO_DEVICE_MAIN environment variable set by the installer
  disko.devices = {
    disk = {
      main = {
        device = "/dev/\${DISKO_DEVICE_MAIN}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              type = "EF00";
              size = "1G";
              label = "BOOT";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0022" "dmask=0022"];
                extraArgs = ["-n" "BOOT"];
              };
            };
            root = {
              size = "100%";
              label = "nixos";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                mountOptions = ["noatime"];
                extraArgs = ["-L" "nixos"];
              };
            };
          };
        };
      };
    };
  };

  # Use filesystem labels for mounting (works regardless of device name)
  fileSystems."/" = lib.mkForce {
    device = "/dev/disk/by-label/nixos";
    fsType = "xfs";
    options = ["noatime"];
  };

  fileSystems."/boot" = lib.mkForce {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };
}
