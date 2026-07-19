{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.ruby;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    ruby # Ruby programming language
    ruby-lsp # Ruby language server
    rufo # Ruby code formatter
    solargraph # Ruby language server
    rubocop # Ruby linter and formatter
  ]);
}
