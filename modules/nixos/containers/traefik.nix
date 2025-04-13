{
  pkgs,
  lib,
  config,
  ...
}: let
  hostname = "knoopx.net";

  hostServices = {
    "search" = config.services.searx.settings.server.port;
    "glance" = 9000;
  };

  providers = (pkgs.formats.yaml {}).generate "traefik-providers.yaml" {
    http = {
      # middlewares =
      #   lib.mapAttrs (
      #     k: v: {
      #       ipWhiteList = {
      #         sourceRange = [
      #           "127.0.0.1/32"
      #           # "192.168.1.0/24"
      #         ];
      #       };
      #     }
      #   )
      #   hostServices;

      routers =
        lib.mapAttrs (
          k: v: {
            service = k;
            rule = "Host(`${k}.knoopx.net`)";
            # rule = "Host(`${k}.knoopx.net`) && ( ClientIP(172.16.1.0/24) || ClientIP(192.168.1.0/24) )";
            entryPoints = ["http"];
          }
        )
        hostServices;

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
        hostServices;
    };
  };
in {
  virtualisation.oci-containers.containers = {
    traefik = {
      autoStart = true;
      image = "traefik:latest";
      ports = ["80:80"];
      # ports = ["80:80" "8080:8080"];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        "${providers}:/etc/traefik/dynamic/dynamic.yml"
      ];
      cmd = [
        "--providers.docker=true"
        "--providers.docker.defaultRule=Host(`{{ normalize .Name }}.${hostname}`)"
        "--providers.file.directory=/etc/traefik/dynamic"
        "--global.sendAnonymousUsage=false"
        "--global.checkNewVersion=false"
        "--api.dashboard=true"
        "--api.insecure=true"
        "--accesslog=true"
        "--entryPoints.http.address=:80"
        "--entryPoints.http.forwardedHeaders.trustedIPs=192.168.1.1"
        # "--log.level=DEBUG"
      ];
      labels = {
        "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
        # "traefik.http.routers.api.service" = "api@internal";
        # "traefik.http.routers.api.middlewares" = "authelia@docker";

        # "traefik.http.routers.search.rule" = "Host(`search.knoopx.net`)";
        # "traefik.http.services.search.loadbalancer.server.port" = "8081";
        # "traefik.http.routers.search.entrypoints" = "web";
        # # "traefik.http.routers.search.tls" = "true";

        # "traefik.http.routers.glance.rule" = "Host(`glance.knoopx.net`)";
        # "traefik.http.services.glance.loadbalancer.server.port" = "9000";
      };
      extraOptions = ["--network=host"];
    };
  };
}
