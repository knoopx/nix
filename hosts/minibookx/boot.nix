{pkgs, ...}: {
  services = {
    scx.enable = true;
    # scx.package = pkgs.scx_git.full;
    scx.scheduler = "scx_lavd";
  };

  boot = {
    kernelParams = ["acpi_override=1"];
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

      prepend = let
        acpi-override = pkgs.stdenv.mkDerivation {
          name = "acpi-override";
          CPIO_PATH = "kernel/firmware/acpi";
          src = ./acpi;
          nativeBuildInputs = with pkgs; [acpica-tools cpio];
          installPhase = ''
            mkdir -p $CPIO_PATH
            iasl -tc mxc6655-override.asl
            cp mxc6655-override.aml $CPIO_PATH
            find kernel | cpio -H newc --create > acpi_override
            cp acpi_override $out
          '';
        };
      in [(toString acpi-override)];
    };

    loader = {
      # systemd-boot.enable = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;

        extraConfig = ''
          export GRUB_FB_ROTATION=270
          GRUB_FB_ROTATION=270
          set rotation=270
        '';

        gfxmodeEfi = "1200x1920x32";
        gfxpayloadEfi = "keep";
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
