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
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
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
