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
      image = "ghcr.io/imagegenius/immich:cuda";
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
      # image = "redis";
      image = "valkey/valkey:8-bookworm";
      extraOptions = [
        "--network=${name}"
      ];
      labels = {
        "traefik.enable" = "false";
      };
    };

    "${name}-postgres" = {
      autoStart = true;
      image = "ghcr.io/immich-app/postgres:14-vectorchord0.3.0-pgvectors0.2.0";
      volumes = [
        "${root}/pgdata:/var/lib/postgresql/data"
      ];
      environment = {
        POSTGRES_USER = name;
        POSTGRES_PASSWORD = name;
        POSTGRES_DB = name;

        POSTGRES_SHARED_BUFFERS = "256MB";
        POSTGRES_EFFECTIVE_CACHE_SIZE = "1GB";
        POSTGRES_MAINTENANCE_WORK_MEM = "64MB";
        POSTGRES_CHECKPOINT_COMPLETION_TARGET = "0.9";
        POSTGRES_WAL_BUFFERS = "16MB";
        POSTGRES_DEFAULT_STATISTICS_TARGET = "100";
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
