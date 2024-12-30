_: {
  imports = [
    ../modules/home-manager/theming/kitty.nix
    ../modules/home-manager/theming/firefox.nix
    ../modules/home-manager/gnome/dconf.nix
    ../modules/home-manager/gnome/packages.nix
    ../modules/home-manager/gnome/programs.nix
    ../modules/home-manager/gnome/easy-effects.nix
    ../modules/home-manager/gnome/gaming.nix
    ../modules/home-manager/gnome/xdg.nix
    ../modules/home-manager/gnome/gtk.nix
    ../modules/home-manager/headless/programs.nix
  ];

  home = {
    stateVersion = "24.05";
    username = "knoopx";
    homeDirectory = "/home/knoopx";
  };
}
