{pkgs, ...} @ inputs: let
  listNixModulesRecusive = import ../../lib/listNixModulesRecusive.nix inputs;
  system = "x86_64-linux";
in {
  imports =
    [
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  networking.hostName = "minibookx";
  nix.settings.system-features = [
  ];

  nixpkgs = {
    hostPlatform = {
      inherit system;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.11";

  boot.kernelPackages = pkgs.linuxPackages_zen;

  services.minibook-support.enable = true;

  # TODOS

  # astal-shell position
  # astal-shell battery widget
  # brightness control
  # cpu scheduler
  # keyboard layout
  # swap alt<->window keys
  # tablet-mode
  # display size in settings
}
