{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.traefik-proxy;

  providers = (pkgs.formats.yaml {}).generate "traefik-providers.yaml" {
    http = {
      routers =
        lib.mapAttrs (
          k: v: {
            service = k;
            rule = "Host(`${k}.${cfg.domain}`)";
            entryPoints = ["http"];
          }
        )
        cfg.hostServices;

      services =
        lib.mapAttrs (
          k: v: {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:${toString v}";
                }
              ];
            };
          }
        )
        cfg.hostServices;
    };
  };
in {
  options.services.traefik-proxy = {
    enable = lib.mkEnableOption "Traefik reverse proxy";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "knoopx.net";
      description = "Base domain for services";
    };

    hostServices = lib.mkOption {
      type = lib.types.attrsOf lib.types.port;
      default = {};
      description = "Map of service names to their local ports";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      traefik = {
        autoStart = true;
        image = "traefik:latest";
        ports = ["80:80"];
        volumes = [
          "/var/run/podman/podman.sock:/var/run/docker.sock:ro"
          "${providers}:/etc/traefik/dynamic/dynamic.yml"
        ];
        cmd = [
          "--providers.docker=true"
          "--providers.docker.defaultRule=Host(`{{ normalize .Name }}.${cfg.domain}`)"
          "--providers.file.directory=/etc/traefik/dynamic"
          "--global.sendAnonymousUsage=false"
          "--global.checkNewVersion=false"
          "--api.dashboard=true"
          "--api.insecure=true"
          "--accesslog=true"
          "--entryPoints.http.address=:80"
          "--entryPoints.http.forwardedHeaders.trustedIPs=192.168.1.1"
        ];
        labels = {
          "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
        };
        extraOptions = ["--network=host"];
      };
    };
  };
}
