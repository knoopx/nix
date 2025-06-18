{pkgs, ...}: {
  services = {
    scx.enable = true;
    # scx.package = pkgs.scx_git.full;
    scx.scheduler = "scx_lavd";
  };

  boot = {
    kernelModules = ["kvm-intel"];
    blacklistedKernelModules = ["snd_hda_intel"];
    extraModulePackages = [];
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';

    kernelPackages = pkgs.linuxPackages_zen;
    kernel.sysctl = {
    };

    plymouth.enable = false;
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];

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
