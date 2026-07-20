{config, ...}: {
  services = {
    udev.extraRules = ''
      # Disable ASUS USB Audio
      SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1b9b", ATTR{authorized}="0"

      # Block usb1-port11 — phantom detection / enumeration failure causing 1min shutdown hang
      SUBSYSTEM=="usb", KERNEL=="1-11", ATTR{authorized}="0"
    '';

    plex = {
      enable = true;
      group = "wheel";
      user = config.defaults.username;
    };

    traefik-proxy = {
      enable = true;
      domain = "knoopx.net";
      hostServices = {
        glance = 9000;
      };
    };
  };
}
