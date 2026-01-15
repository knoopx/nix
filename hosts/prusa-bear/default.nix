{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
} @ inputs: let
  system = "aarch64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports =
    [
      "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
      "${modulesPath}/profiles/minimal.nix"
    ]
    ++ (listNixModulesRecusive ../../modules/nixos)
    ++ [ ./services.nix ];

  networking.hostName = "prusa-bear";

  system = {
    stateVersion = "25.05";
  };

  # Use Raspberry Pi 3 kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi3;

  # Enable SSH for remote access
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";  # For initial setup

  # Disable unnecessary services for minimal image
  services.xserver.enable = lib.mkForce false;
  services.displayManager.enable = lib.mkForce false;
  services.greetd.enable = lib.mkForce false;
  services.btrfs.autoScrub.enable = lib.mkForce false;

  # Set up user
  users.users.${config.defaults.username} = {
    isNormalUser = true;
    extraGroups = [ "klipper" "moonraker" ];
    openssh.authorizedKeys.keys = [
      # Add your SSH public key here
    ];
  };

  home-manager.users.${config.defaults.username} = {
    imports = [ ../../home/${config.defaults.username}.nix ];
  };

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
    overlays = [];  # Minimal image, no global overlays
  };

  # Ensure systemd services are enabled
  systemd.services.moonraker.wantedBy = lib.mkForce [ "multi-user.target" ];
}