{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  virtualisation = {
    # lxd.enable = true;
    # virtualbox.host.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
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

    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "daily";
      enableOnBoot = true;
    };
  };
}
