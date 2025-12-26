{...}: {
  boot = {
    extraModprobeConfig = ''
      options snd_hda_intel enable=0
    '';

    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
}
