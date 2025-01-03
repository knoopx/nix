_: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./nix-ld.nix
    ./nix.nix
    ./nixpkgs.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./system.nix
    ./theming.nix
    ./users.nix
  ];

  documentation.enable = false;
}
