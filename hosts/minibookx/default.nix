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
      ./overlays.nix
      ./boot.nix
      ./hardware.nix
    ]
    ++ (listNixModulesRecusive ../../modules/nixos);

  boot.initrd.prepend = let
    acpi-override = pkgs.stdenv.mkDerivation {
      name = "acpi-override";
      CPIO_PATH = "kernel/firmware/acpi";

      src = ./acpi;

      nativeBuildInputs = with pkgs; [
        acpica-tools
        cpio
      ];

      installPhase = ''
        mkdir -p $CPIO_PATH
        iasl -tc acpi/mxc6655-override.asl
        cp acpi/mxc6655-override.aml $CPIO_PATH
        find kernel | cpio -H newc --create > acpi_override
        cp acpi_override $out
      '';
    };
  in [(toString acpi-override)];

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
  boot.kernelParams = ["acpi_override=1"];

  system.stateVersion = "25.11";

  services.minibook-support.enable = true;

  defaults.display.width = 1920;
  defaults.display.height = 1200;
  defaults.display.defaultColumnWidthPercent = 1.0;
  defaults.display.columnWidthPercentPresets = [0.5 0.75];

  # TODOS

  # cpu scheduler
  # swap alt<->window keys (kmonad/keyd)
  # tablet-mode
  # default niri widths
  # home encryption
  # proper locking
  # energy saving
  # vibeapp height
  # charge limit 80%
  # 60hz edid
  # low-batery/charging notifications

  home-manager.users.${config.defaults.username} = import ../../home/${config.defaults.username}.nix;

  # https://github.com/petitstrawberry/minibook-support/issues/17
  # https://github.com/arkaitzsilva/dotfiles/blob/b58798fd6e6cfeccfc3148c444a94ac00bca2cd2/hosts/Alienware13/dsdt-override.nix#L5
}
