{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.javascript;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    bun # JavaScript/TypeScript runtime
    pnpm # Node.js package manager
    nodejs_latest # Node.js JavaScript runtime
    typescript-language-server # TypeScript language server
    typescript-go # Go implementation of TypeScript
  ]);
}
