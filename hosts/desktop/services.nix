{
  pkgs,
  defaults,
  ...
}: {
  services = {
    udev.packages = with pkgs; [
      via
    ];
    pulseaudio.enable = false;
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;

    systembus-notify = {
      enable = true;
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        systembus-notify.enable = true;
      };
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    sunshine = {
      enable = false;
      autoStart = true;
      capSysAdmin = true;
    };

    plex = {
      enable = true;
      group = "wheel";
      user = defaults.username;
    };

    atd = {
      enable = true;
      allowEveryone = true;
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
