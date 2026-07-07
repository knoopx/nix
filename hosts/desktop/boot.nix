{lib, ...}: {
  boot = {
    blacklistedKernelModules = [
      "snd_hda_intel" # NVIDIA HDMI audio probe fails; use ALSA directly via NVIDIA driver
    ];

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

    plymouth.enable = lib.mkForce false;
    
    binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
