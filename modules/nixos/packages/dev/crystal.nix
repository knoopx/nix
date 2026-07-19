{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.crystal;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    crystal # Crystal programming language
    crystalline # Crystal language server
    shards # Crystal package manager
  ]);
}
