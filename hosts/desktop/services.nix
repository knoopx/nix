{
  pkgs,
  config,
  ...
}: {
  services = {
    udev.packages = with pkgs; [
      via
    ];

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
