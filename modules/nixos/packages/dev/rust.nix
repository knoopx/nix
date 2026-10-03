{ pkgs, config, lib, ... }:
let
  enabled = config.defaults.development.rust;
in
{
  environment.systemPackages = lib.mkIf enabled (with pkgs; [
    cargo # Rust package manager and build tool
    clippy # Rust linter
    rustc # Rust compiler
    rustfmt # Rust code formatter
    rust-analyzer # Rust language server
  ]);
}
