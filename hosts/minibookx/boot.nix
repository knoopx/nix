{pkgs, ...}: {
  services = {
    scx.enable = true;
    # scx.package = pkgs.scx_git.full;
    scx.scheduler = "scx_lavd";
  };

  boot = {
    kernelParams = [
      "915.enable_fbc=0"
      "video=efifb:mode=0"
      "fbcon=rotate:1"
      "video=DSI-1:panel_orientation=right_side_up"
    ];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_zen;

    plymouth.enable = false;
    crashDump.enable = false;
    tmp.cleanOnBoot = true;

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
