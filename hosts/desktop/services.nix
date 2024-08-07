{
  pkgs,
  defaults,
  config,
  lib,
  ...
}: {
  systemd = {
    services = {
      # searxng = {
      # };
      # environment.systemPackages = with pkgs; [
      #     searxng
      #   ];
      # ollama = {
      #   serviceConfig = {
      #     DeviceAllow = lib.mkForce [
      #       "char-nvidia-caps"
      #       "char-nvidia-frontend"
      #       "char-nvidia-uvm"
      #       "char-nvidiactl"
      #     ];
      #   };
      # };
    };
  };

  services = {
    btrfs.autoScrub.enable = true;
    fstrim.enable = true;

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

    silverbullet = {
      enable = true;
      user = defaults.username;
      group = "users";
      listenPort = 3900;
    };

    caddy = {
      enable = true;

      email = defaults.primary-email;

      globalConfig = ''
        http_port    80
        auto_https   off
        admin        off
        persist_config off
        skip_install_trust
      '';

      virtualHosts."silverbullet.knoopx.net:80".extraConfig = ''
        reverse_proxy http://localhost:${toString config.services.silverbullet.listenPort}
      '';
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
