{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.go;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    go # Go programming language
  ]);
}
