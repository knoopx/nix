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

  networking.hostName = "unattended-install";

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  system = {
    stateVersion = "25.05";
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

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

  services.btrfs.autoScrub.enable = lib.mkForce false;

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;

  disko.devices = {
    disk = {
      main = {
        device = "/dev/$DISKO_DEVICE_MAIN";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["fmask=0022" "dmask=0022"];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                mountOptions = ["noatime"];
              };
            };
          };
        };
      };
    };
  };
}
