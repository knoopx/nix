{...}: {
  imports = [
    ./headless/hardware.nix
    ./headless/networking.nix
    # ./headless/nix-ld.nix
    ./headless/nix.nix
    ./headless/nixpkgs.nix
    ./headless/packages.nix
    ./headless/programs.nix
    ./headless/services.nix
    ./headless/system.nix
    ./headless/theming.nix
    ./headless/users.nix
  ];

  documentation.enable = false;
}
