_: {
  imports = [
    # ../hosts/headless/nixpkgs.nix
    ./gnome/dconf.nix
    ./gnome/packages.nix
    ./gnome/programs.nix
    ./gnome/easy-effects-irs.nix
    ./gnome/xdg.nix
    ./gnome/gtk.nix
    ./headless/programs.nix
  ];

  home = {
    stateVersion = "24.05";
    username = "knoopx";
    homeDirectory = "/home/knoopx";
  };
}
