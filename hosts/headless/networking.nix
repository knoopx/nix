{
  config,
  lib,
  ...
}: {
  services = {
    tailscale.enable = false;
  };

  networking = {
    networkmanager.enable = true;
    # useDHCP = true;

    firewall = {
      enable = false;
      # trustedInterfaces = lib.mkIf config.services.tailscale.enable ["tailscale0"];
    };
  };
}
