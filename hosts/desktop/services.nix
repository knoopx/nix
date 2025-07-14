{
  pkgs,
  config,
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
      user = config.defaults.username;
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
        nix = config.services.nix-serve.port;
      };
    };

    # https://nix.dev/tutorials/nixos/binary-cache-setup.html
    # nix-store --generate-binary-cache-key nix.knoopx.net /var/secrets/cache-private-key.pem /var/secrets/cache-public-key.pem
    nix-serve = {
      enable = true;
      port = 5000;
      secretKeyFile = "/var/secrets/cache-private-key.pem";
    };
  };
}
