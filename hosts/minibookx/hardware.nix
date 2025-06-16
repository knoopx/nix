{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/741e2c17-41f6-44a2-b7ee-5317b5dd0494";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/948C-D19F";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };
}
