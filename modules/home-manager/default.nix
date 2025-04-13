{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./easy-effects
    ./firefox
    ./fish.nix
    ./gaming.nix
    ./terminal.nix
    ./git.nix
    ./gnome
    ./kitty.nix
    ./yazi.nix
    ./vscode
    ./services.nix
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
