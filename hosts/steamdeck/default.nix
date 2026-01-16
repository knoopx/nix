{
  config,
  nixosConfig,
  lib,
  pkgs,
  modulesPath,
  ...
} @ inputs: let
  system = "x86_64-linux";
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
in {
  imports = (listNixModulesRecusive ../../modules/nixos);

  # Basic hardware
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  networking.hostName = "steamdeck";

  system = {
    stateVersion = "25.05";
  };

  # Enable pegasus-frontend
  environment.systemPackages = with pkgs; [
    pegasus-frontend
  ];

  # Autologin
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = config.defaults.username;

  # Enable X11
  services.xserver.enable = lib.mkForce true;
  services.xserver.desktopManager.xfce.enable = false; # No desktop
  services.xserver.displayManager.session = lib.singleton {
    name = "pegasus";
    start = ''
      ${pkgs.pegasus-frontend}/bin/pegasus-frontend &
      waitPID=$!
    '';
  };

  # Set default session to pegasus
  services.displayManager.defaultSession = "pegasus";

  # Disable gdm, use lightdm
  services.displayManager.gdm.enable = lib.mkForce false;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.mini.enable = true;
  services.xserver.displayManager.lightdm.greeters.mini.user = config.defaults.username;
  services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
    [greeter]
    show-password-label = false
    show-input-cursor = false
    invalid-password-text =
  '';

  # Disable unnecessary services for minimal image
  services.btrfs.autoScrub.enable = lib.mkForce false;
  services.btrfs.autoScrub.fileSystems = [];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  # Home manager config
  home-manager.users.${config.defaults.username} = {
    imports = [../../home/${config.defaults.username}.nix];
    # No additional config needed for now
  };
}