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
    ./ghostty.nix
    ./git.nix
    ./gnome
    ./kitty.nix
    ./navi
    ./vscode.nix
    ./yazi.nix
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
