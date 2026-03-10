{
  lib,
  config,
  ...
}: {
  systemd.services.ModemManager.enable = false;

  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [22 80];
    };
  };
}
