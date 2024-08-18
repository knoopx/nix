{
  config,
  pkgs,
  ...
}: {
  # systemd.services.init-filerun-network-and-files = {
  #   description = "Create the network bridge for Immich.";
  #   after = ["network.target"];
  #   wantedBy = ["multi-user.target"];

  #   serviceConfig.Type = "oneshot";
  #   script = let
  #     dockercli = "${config.virtualisation.docker.package}/bin/docker";
  #   in ''
  #     # host network
  #     check=$(${dockercli} network ls | grep "host" || true)
  #     if [ -z "$check" ]; then
  #       ${dockercli} network create host
  #     else
  #       echo "host already exists in docker"
  #     fi
  #   '';
  # };

  # Immich
  environment.defaultPackages = [
    pkgs.nvidia-container-toolkit
  ];

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
    oci-containers.backend = "docker";
  };

  # systemd.services."docker-network" = {
  #   path = [pkgs.docker];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStop = "docker network rm -f docker-network";
  #   };
  #   script = ''
  #     docker network inspect docker-network || docker network create docker-network
  #   '';
  #   partOf = ["docker-network.target"];
  #   wantedBy = ["docker-network.target"];
  # };

  virtualisation.oci-containers.containers = {
    # immich = {
    #   autoStart = true;
    #   image = "ghcr.io/imagegenius/immich:latest";
    #   volumes = [
    #     "/mnt/storage/Photos/immich/photos:/photos"
    #     "/mnt/storage/Photos/immich/config:/config"
    #     # "/mnt/storage/Photos/immich/config/machine-learning:/config/machine-learning"
    #   ];
    #   ports = ["8080:2283"];
    #   environment = {
    #     PUID = "1000";
    #     PGID = "1000";
    #     TZ = "Europe/Berlin"; # Change this to your timezone
    #     DB_HOSTNAME = "postgres";
    #     DB_USERNAME = "postgres";
    #     DB_PASSWORD = "postgres";
    #     DB_DATABASE_NAME = "immich";
    #     REDIS_HOSTNAME = "redis";
    #   };
    #   extraOptions = [
    #     # "--network=docker-network"
    #     # "--gpus=all"
    #   ];
    # };

    # redis = {
    #   autoStart = true;
    #   image = "redis";
    #   ports = ["6379:6379"];
    #   # extraOptions = ["--network=docker-network"];
    # };

    # postgres = {
    #   autoStart = true;
    #   image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
    #   ports = ["5432:5432"];
    #   volumes = [
    #     "/mnt/storage/Photos/immich/pgdata:/var/lib/postgresql/data"
    #   ];
    #   environment = {
    #     POSTGRES_USER = "postgres";
    #     POSTGRES_PASSWORD = "postgres";
    #     POSTGRES_DB = "immich";
    #   };
    #   # extraOptions = ["--network=docker-network"];
    # };
  };
}
