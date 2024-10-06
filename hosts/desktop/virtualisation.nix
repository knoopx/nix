{pkgs, ...}: {
  virtualisation = {
    # lxd.enable = true;
    # virtualbox.host.enable = true;
    # libvirtd = {
    #   enable = false;
    #   qemu = {
    #     package = pkgs.qemu_kvm;
    #     runAsRoot = true;
    #     swtpm.enable = true;
    #     vhostUserPackages = [pkgs.virtiofsd];
    #     ovmf = {
    #       enable = true;
    #       # packages = [
    #       #   (pkgs.OVMF.override {
    #       #     secureBoot = true;
    #       #     tpmSupport = true;
    #       #   })
    #       #   .fd
    #       # ];
    #     };
    #   };
    # };

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
