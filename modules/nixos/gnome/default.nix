{pkgs, ...}: {
  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./xdg.nix
  ];
}
