{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./easy-effects.nix
    ./firefox
    ./fish.nix
    ./gaming.nix
    ./git.nix
    ./kitty.nix
    ./vscode.nix
    ./navi
    ./yazi.nix
    ./gnome
  ];

  home.packages = with pkgs; [
    fuzzy
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
