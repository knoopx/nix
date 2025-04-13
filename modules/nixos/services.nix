{
  pkgs,
  lib,
  defaults,
  ...
}: {
  services = {
    timesyncd.enable = lib.mkDefault true;
    fwupd.enable = true;
    printing.enable = false;
    libinput.enable = false;

    # atd.enable = true;

    # https://www.reddit.com/r/linux_gaming/comments/11yp7ig/pipewire_audio_stuttering_when_playing_games_or/
    pipewire = {
      enable = true;
      # alsa.enable = false;
      # pulse.enable = true;
      # wireplumber.enable = false;
      # jack.enable = false;
      # systemWide = true;

      # extraConfig.pipewire."92-low-latency" = {
      #   "context.properties" = {
      #     "default.clock.rate" = 48000;
      #     "default.clock.quantum" = 32;
      #     "default.clock.min-quantum" = 32;
      #     "default.clock.max-quantum" = 32;

      #     # default.clock.rate = 48000;
      #     # default.clock.allowed-rates = [48000];
      #     # default.clock.quantum = 2048;
      #     # default.clock.min-quantum = 1024;
      #   };
      # };
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };

    searx = {
      enable = true;
      package = pkgs.searxng;
      runInUwsgi = false;
      settings = {
        general.enable_metrics = false;
        search = {
          safe_search = 0;
          formats = ["html" "json"];
        };
        server = {
          port = 8081;
          bind_address = "0.0.0.0";
          # bind_address = "127.0.0.1";
          # public_instance = true;
          # limiter = false;
          # http_protocol_version = "1.1";
          secret_key = "helloworld";
        };
        # ui = {
        # default_locale = "en";
        # theme_args.simple_style = "dark";
        # };
      };
      # environmentFile = config.sops.secrets.searx-env.path;
    };
  };
}
