_: {
  imports = [
    ../modules/home-manager/easy-effects.nix
    ../modules/home-manager/firefox.nix
    ../modules/home-manager/fish.nix
    ../modules/home-manager/gaming.nix
    ../modules/home-manager/git.nix
    ../modules/home-manager/kitty.nix
    ../modules/home-manager/vscode.nix
    ../modules/home-manager/gnome/dconf.nix
    ../modules/home-manager/gnome/gtk.nix
    ../modules/home-manager/gnome/packages.nix
    ../modules/home-manager/gnome/xdg.nix
    ../modules/home-manager/headless/programs.nix
  ];

  home = {
    stateVersion = "24.05";
    username = "knoopx";
    homeDirectory = "/home/knoopx";
  };
}
