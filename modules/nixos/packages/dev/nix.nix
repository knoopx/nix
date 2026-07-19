{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.nix;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    alejandra # Nix code formatter
    nixd # Nix language server
  ]);
}
