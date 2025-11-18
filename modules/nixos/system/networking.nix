{
  lib,
  config,
  ...
}: {
  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [22 80];
    };
  };
}
