{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./defaults.nix
    ./defaults/linux.nix
    ../modules/hardware/nvidia.nix
    ../modules/desktops/gnome.nix
    ./desktop/virtualisation.nix
    ./desktop/hardware.nix
    ./desktop/filesystems.nix
    ./desktop/boot.nix
    ./desktop/programs.nix
    ./desktop/services.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    autoUpgrade.enable = true;
    stateVersion = "24.05";
  };

  networking.hostName = "desktop";
}
