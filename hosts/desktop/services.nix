{...}: {
  services = {
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;

    systembus-notify = {
      enable = true;
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        x11.enable = true;
        # wall.enable = true;
      };
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
    };

    ollama = {
      enable = true;
      acceleration = "cuda";
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };

    mpd = {
      enable = false;
      user = "pipewire";
      musicDirectory = "/mnt/mixed/Music";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Output"
        }
      '';

      network.listenAddress = "any";
    };

    # plex = {
    #   enable = true;
    #   dataDir = "/var/lib/plex";
    #   # openFirewall = true;
    #   user = "plex";
    #   group = "plex";
    # };
  };
}
