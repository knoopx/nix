{config, ...}: let
  name = "photos";
  root = "/mnt/storage/immich";
in {
  systemd.services."${name}-network" = {
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig.Type = "oneshot";
    script = let
      podman = "${config.virtualisation.podman.package}/bin/podman";
    in ''
      check=$(${podman} network ls | grep "${name}" || true)
      if [ -z "$check" ]; then
        ${podman} network create ${name}
      else
        echo "${name} network already exists"
      fi
    '';
  };

  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "ghcr.io/imagegenius/immich:latest";
      volumes = [
        "${root}/photos:/photos"
        "${root}/config:/config"
      ];

      ports = [
        "5050:8080"
      ];

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Europe/Madrid";
        REDIS_HOSTNAME = "${name}-redis";
        DB_HOSTNAME = "${name}-postgres";
        DB_USERNAME = name;
        DB_PASSWORD = name;
        DB_DATABASE_NAME = name;
      };
      extraOptions = [
        "--device=nvidia.com/gpu=all"
        "--network=${name}"
      ];
      dependsOn = [
        "${name}-redis"
        "${name}-postgres"
      ];
    };

    "${name}-redis" = {
      autoStart = true;
      image = "redis";
      extraOptions = [
        "--network=${name}"
      ];
      labels = {
        "traefik.enable" = "false";
      };
    };

    "${name}-postgres" = {
      autoStart = true;
      image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
      volumes = [
        "${root}/pgdata:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_USER = name;
        POSTGRES_PASSWORD = name;
        POSTGRES_DB = name;
      };
      extraOptions = [
        "--network=${name}"
      ];
      labels = {
        "traefik.enable" = "false";
      };
    };
  };
}
