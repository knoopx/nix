{pkgs, ...}: {
  services = {
    # scx.enable = true;
    # scx.package = pkgs.scx_git.full;
    # scx.scheduler = "scx_lavd";
  };

  boot = {
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
    };

    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
