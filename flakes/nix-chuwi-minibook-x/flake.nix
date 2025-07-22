{
  description = "NixOS configuration for Chuwi Minibook X and related services";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {nixos-hardware, ...}: let
  in {
    nixosModules = {
      default = import ./modules/nixos/default.nix {
        inherit nixos-hardware;
      };
    };
    homeManagerModules = {
      default = ./modules/home-manager/default.nix;
    };
    packages = {
      minibook-dual-accelerometer = import ./pkgs/minibook-dual-accelerometer.nix {};
      chuwi-ltsm-hack-module = import ./pkgs/chuwi-ltsm-hack-module.nix {};
    };
  };
}
