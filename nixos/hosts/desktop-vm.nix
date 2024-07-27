{...}: {
  imports = [
    ./defaults.nix
    ../modules/desktops/gnome.nix
    ./desktop/services.nix
  ];
  networking.hostName = "desktop-vm";
}
