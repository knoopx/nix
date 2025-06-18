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
      ./boot.nix
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  system.stateVersion = "25.11";

  services.minibook-support.enable = true;

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
  defaults.display.defaultColumnWidthPercent = 1.0;
  defaults.display.columnWidthPercentPresets = [0.5 0.75];

  # TODOS

  # swap alt<->window keys (kmonad/keyd)
  # tablet-mode
  # home encryption
  # proper locking
  # energy saving
  # charge limit 80%
  # 60hz edid
  # low-batery/charging notifications
  # battery meter not updating

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;

  # https://github.com/petitstrawberry/minibook-support/issues/17
  # https://github.com/arkaitzsilva/dotfiles/blob/b58798fd6e6cfeccfc3148c444a94ac00bca2cd2/hosts/Alienware13/dsdt-override.nix#L5
}
