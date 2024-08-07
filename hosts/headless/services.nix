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

    # https://www.reddit.com/r/linux_gaming/comments/11yp7ig/pipewire_audio_stuttering_when_playing_games_or/
    pipewire = {
      enable = true;
      alsa.enable = false;
      pulse.enable = true;
      # jack.enable = false;
      # wireplumber.enable = false;
      # systemWide = true;

      # extraConfig.pipewire."92-low-latency" = {
      #   "context.properties" = {
      #     "default.clock.rate" = 48000;
      #     "default.clock.quantum" = 32;
      #     "default.clock.min-quantum" = 32;
      #     "default.clock.max-quantum" = 64;
      #     #   "default.clock.allowed-rates" = [48000];
      #     #   "default.clock.quantum" = 2048;
      #     #   "default.clock.min-quantum" = 1024;

      #     # "default.clock.quantum" = 32;
      #     # "default.clock.min-quantum" = 32;
      #     # "default.clock.max-quantum" = 32;

      #     # "default.clock.rate" = 44100;
      #     # "default.clock.quantum" = 512;
      #     # "default.clock.min-quantum" = 512;
      #     # "default.clock.max-quantum" = 512;
      #   };
      # };
    };

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
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
  };
}
