{ pkgs, config, ... }: {
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

    containers.storage.settings = {
      storage = {
        driver = "btrfs";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };
  };

  home-manager.users.${config.defaults.username} = {
    home.packages = with pkgs; [
      podman-compose # Docker-compose implementation with podman
    ];

    home.file.".config/containers/registries.conf".text = ''   
      unqualified-search-registries = ["docker.io"]            
    '';
  };
}
