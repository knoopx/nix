{pkgs, ...}: {
  virtualisation = {
    # lxd.enable = true;
    # virtualbox.host.enable = true;
    spiceUSBRedirection.enable = true;
    # libvirtd = {
    #   enable = true;
    #   qemu = {
    #     #     package = pkgs.qemu_kvm;
    #     # runAsRoot = false;
    #     #     swtpm.enable = true;
    #     #     vhostUserPackages = [pkgs.virtiofsd];
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

    podman = {
      enable = true;

      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];
}
