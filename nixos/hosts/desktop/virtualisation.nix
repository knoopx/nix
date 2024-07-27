{
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  virtualisation = {
    # lxd.enable = true;
    # virtualbox.host.enable = true;
    # libvirtd.enable = true;
    docker = {
      enable = true;
      autoPrune.enable = true;
      autoPrune.dates = "daily";
      enableOnBoot = true;
    };
  };
}
