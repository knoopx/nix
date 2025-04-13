{
  lib,
  config,
  ...
}: {
  services = {
    tailscale.enable = false;
  };

  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = false;
      trustedInterfaces = lib.mkIf config.services.tailscale.enable ["tailscale0"];
    };

    # extraHosts = ''
    #   127.0.0.1 search.knoopx.net
    # '';
  };
}
