{
  defaults,
  lib,
  ...
}: {
  services = {
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
        x11.enable = true;
        # wall.enable = true;
      };
    };

    earlyoom = {
      enable = true;
      enableNotifications = true;
    };

    sunshine = {
      # enable = true;
      autoStart = true;
      capSysAdmin = true;
    };

    mpd = {
      # enable = true;
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

    plex = {
      enable = true;
      group = "wheel";
      user = defaults.username;
    };
  };

  systemd.services.plex.serviceConfig = {
    KillSignal = lib.mkForce "SIGKILL";
    TimeoutStopSec = 10;
    ProtectHome = lib.mkForce false;
  };
}
