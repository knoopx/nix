_: {
  imports = [
    ../modules/nixos/headless/nix.nix
    ../modules/nixos/headless/nixpkgs.nix
    ../modules/nixos/headless/packages.nix
    ../modules/nixos/headless/system.nix
    ../modules/nixos/headless/theming
  ];

  networking.hostName = "live";
}
