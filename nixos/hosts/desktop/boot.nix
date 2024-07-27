{pkgs, ...}: {
  boot = {
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];

    loader = {
      # TODO:
      # MSI motherboard will wipe out boot entries if efi is not installed at fallback location
      # run `grub-install --removable ...` to also install grub at fallback location
    };
  };
}
