{...}: {
  # services = {
  #   tailscale.enable = true;
  # };

  networking = {
    networkmanager.enable = true;
    # useDHCP = true;
    firewall.enable = false;
    # firewall.trustedInterfaces = ["tailscale0"];
  };
}
