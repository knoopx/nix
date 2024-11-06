_: {
  virtualisation = {
    # lxd.enable = true;
    # virtualbox.host.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        #     package = pkgs.qemu_kvm;
        # runAsRoot = false;
        #     swtpm.enable = true;
        #     vhostUserPackages = [pkgs.virtiofsd];
        ovmf = {
          enable = true;
          # packages = [
          #   (pkgs.OVMF.override {
          #     secureBoot = true;
          #     tpmSupport = true;
          #   })
          #   .fd
          # ];
        };
      };
    };

    oci-containers.backend = "docker";
    # defaultNetwork.settings.dns_enabled = true;

    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "daily";
      enableOnBoot = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
