{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./easy-effects.nix
    ./firefox
    ./fish.nix
    ./gaming.nix
    ./terminal.nix
    ./git.nix
    ./gnome
    ./kitty.nix
    ./navi
    ./yazi.nix
    ./shamls
    ./vscode
    ./services.nix
    # ./cursor
  ];

  home.packages = with pkgs; [
    fuzzy
    fuzzel
    webkit-shell
    shttp
  ];

  programs = {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 5d --keep 3";
      flake = "${config.home.homeDirectory}/.dotfiles";
    };
  };
}
