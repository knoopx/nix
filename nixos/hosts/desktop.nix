{...}: {
  imports = [
    ./defaults.nix
    ../modules/hardware/nvidia.nix
    ../modules/desktops/gnome.nix
    ./desktop/virtualisation.nix
    ./desktop/hardware.nix
    ./desktop/filesystems.nix
    ./desktop/boot.nix
    ./desktop/programs.nix
    ./desktop/services.nix
  ];
  networking.hostName = "desktop";
}
