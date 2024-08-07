{nixpkgs, ...}: {
  imports = [
    ./headless/nix.nix
    ./headless/nixpkgs.nix
    ./headless/packages.nix
    ./headless/programs.nix
    ./headless/system.nix
    ./headless/theming.nix
  ];

  networking.hostName = "live";
}
