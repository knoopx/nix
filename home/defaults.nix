{pkgs, ...}: {
  imports = [
    ../nixos/hosts/defaults/nixpkgs.nix
    ./defaults/system.nix
    ./defaults/programs.nix
  ];
}
