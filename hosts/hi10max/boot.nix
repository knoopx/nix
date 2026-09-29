{pkgs, lib, ...}: {
  services = {
    # scx.enable = true;
    # scx.package = pkgs.scx_git.full;
    # scx.scheduler = "scx_lavd";
  };

  boot = {
    # 7.x kernel from the nixpkgs-provided source — NO manual fetchurl.
    # nixpkgs (locked 26.11pre) dropped linux_7_0 / linux_7_1 (EOL throws)
    # and exposes linux_7_2 (7.2.x) as the newest 7.x series. The
    # Alder Lake-N / INTC1057 pinctrl + int3472 pair the GC5035 camera
    # needs is present in 7.x, so 7.2 is a fine (newer) match for the
    # Vor-Art 7.0 pair. We take the canonical nixpkgs kernel derivation
    # (pkgs.linuxKernel.kernels.linux_7_2, built from the nixpkgs 7.2
    # source tarball) and add PINCTRL_ALDERLAKE=y via structuredExtraConfig,
    # then wrap it in a full linuxPackages set with linuxPackagesFor (the
    # NixOS "Pinning a kernel version" pattern) so out-of-tree modules build
    # against it. This is a proper kernel DERIVATION (not a function), so
    # the NixOS boot.kernelPackages `apply` re-override works.
    # lib.mkForce: the shared modules/nixos/system/boot.nix also defines
    # boot.kernelPackages (plain definition); in 26.11pre the option is
    # unique, so the host pin must force over the shared default.
    kernelPackages = lib.mkForce (pkgs.recurseIntoAttrs (
      pkgs.linuxPackagesFor (
        pkgs.linuxKernel.kernels.linux_7_2.override {
          structuredExtraConfig = {
            PINCTRL_ALDERLAKE = lib.kernel.yes;
          };
        }
      )
    ));
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

    plymouth.enable = lib.mkForce false;
  };
}
