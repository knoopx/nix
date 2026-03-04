{pkgs, ...}: {
  boot = {
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
        "dm_crypt"
        "cryptd"
      ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
