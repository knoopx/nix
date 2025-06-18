{
  pkgs,
  config,
  ...
} @ inputs: let
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

  defaults.display.width = 1920;
  defaults.display.height = 1200;
  defaults.display.defaultColumnWidthPercent = 1.0;
  defaults.display.columnWidthPercentPresets = [0.5 0.75];

  # TODOS

  # astal-shell position
  # astal-shell battery widget
  # brightness control
  # cpu scheduler
  # keyboard layout
  # swap alt<->window keys (kmonad/keyd)
  # tablet-mode
  # display size in settings
  # default niri widths
  # home encryption
  # proper locking
  # energy saving
  # vibeapp height

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;
}
