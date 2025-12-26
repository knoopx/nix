{
  pkgs,
  config,
  ...
}: {
  services = {
    androidBackup = {
      enable = true;
      # backupDir = "/mnt/storage/Photos/input/Android";
      backupDir = "/home/${config.defaults.username}/Pictures/Camera";
      screenshotsDir = "/home/${config.defaults.username}/Pictures/Screenshots";
      downloadsDir = "/home/${config.defaults.username}/Downloads";
      serialShort = "31051JEHN09244";
    };

    udev.extraRules = ''
      # Disable ASUS USB Audio
      SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="1b9b", ATTR{authorized}="0"
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
        webdav = 5006;
      };
    };
  };
}
