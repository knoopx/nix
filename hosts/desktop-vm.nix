{...}: {
  imports = [
    ../modules/desktops/gnome.nix
    ./defaults.nix
    ./desktop/services.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "desktop-vm";
}
