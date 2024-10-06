{...}: let
  hostname = "knoopx.net";
in {
  virtualisation.oci-containers.containers = {
    traefik = {
      autoStart = true;
      image = "traefik:latest";
      ports = ["80:80" "8080:8080"];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      cmd = [
        "--providers.docker=true"
        "--providers.docker.defaultRule=Host(`{{ normalize .Name }}.${hostname}`)"
        "--api.insecure=true"
        "--global.sendAnonymousUsage=false"
        "--global.checkNewVersion=false"
      ];
      labels = {
        "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
        # "traefik.http.routers.api.service" = "api@internal";
        # "traefik.http.routers.api.middlewares" = "authelia@docker";
      };
      extraOptions = ["--network=host"];
    };
  };
}
