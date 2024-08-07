{pkgs, ...}: {
  chaotic.scx.enable = true;

  boot = {
    kernelModules = ["kvm-intel"];
    blacklistedKernelModules = ["snd_hda_intel"];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_cachyos;
    # .override {
    #   stdenv = pkgs.impureUseNativeOptimizations pkgs.linuxPackages_cachyos.stdenv;
    # };

    plymouth.enable = false;
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];

    # TODO:
    # MSI motherboard will wipe out boot entries if efi is not installed at fallback location
    # run `grub-install --removable ...` to also install grub at fallback location
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        # useOSProber = true;
        efiSupport = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
