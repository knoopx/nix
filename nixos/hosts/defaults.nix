{defaults, ...}: {
  imports = [
    ./defaults/networking.nix
    ./defaults/nix.nix
    ./defaults/nix-ld.nix
    ./defaults/nixpkgs.nix
    ./defaults/packages.nix
    ./defaults/programs.nix
    ./defaults/services.nix
    ./defaults/system.nix
    ./defaults/theming.nix
    ./defaults/users.nix
  ];

  documentation.nixos.enable = false;
}
