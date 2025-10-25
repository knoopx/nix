{
  pkgs,
  config,
  ...
}: {
  services = {
    androidPhotoBackup = {
      enable = true;
      backupDir = "/mnt/storage/Photos/input/Android";
      serialShort = "31051JEHN09244";
    };

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
        webdav = 5006;
      };
    };
  };


}
