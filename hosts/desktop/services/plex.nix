{ lib, ... }: {
  systemd.services.plex.serviceConfig = {
    KillSignal = lib.mkForce "SIGKILL";
    TimeoutStopSec = 10;
    ProtectHome = lib.mkForce false;
  };

  services.traefik-proxy = {
    hostServices = {
      plex = 32400;
    };
  };
}
