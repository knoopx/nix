{config, ...}: let
  name = "roms";
  root = "/mnt/storage/romm";
in {
  virtualisation.oci-containers.containers = {
    "${name}-db" = {
      autoStart = true;

      image = "mariadb:latest";

      environment = {
        MARIADB_ROOT_PASSWORD = "romm";
        MARIADB_DATABASE = "romm";
        MARIADB_USER = "romm-user";
        MARIADB_PASSWORD = "romm";
      };

      volumes = [
        "${root}/mysql_data:/var/lib/mysql"
      ];
    };

    "${name}" = {
      autoStart = true;

      image = "rommapp/romm:latest";
      volumes = [
        "${root}/resources:/romm/resources"
        "${root}/redis-data:/redis-data"
        "/mnt/junk/Roms/no-intro:/romm/library"
        "${root}/assets:/romm/assets"
        "${root}/config:/romm/config"
      ];

      environment = {
        PUID = "1000";
        PGID = "100";
        DB_HOST = "roms-db";
        DB_NAME = "romm";
        DB_USER = "romm-user";
        DB_PASSWD = "romm";
        ROMM_AUTH_SECRET_KEY = "d250f8410bfb2a4adf9ffee1c9b7c80c03a194e4b18bf3b668c3792adad28c12";
        ROMM_HOST = "https://roms.${config.services.traefik-proxy.domain}";
        # IGDB_CLIENT_ID = "your_igdb_client_id_here"; # Generate an ID and SECRET in IGDB
        # IGDB_CLIENT_SECRET = "your_igdb_client_secret_here"; # https://api-docs.igdb.com/#account-creation
        SCREENSCRAPER_USER = "knoopx"; # Use your ScreenScraper username and password
        SCREENSCRAPER_PASSWORD = "kn11px"; # https://docs.romm.app/latest/Getting-Started/Metadata-Providers/#screenscraper
        STEAMGRIDDB_API_KEY = "1ba3fcbec9e58defcc4a7e0709117236"; # https://github.com/rommapp/romm/wiki/Metadata-Providers#steamgriddb
      };

      labels = {
        "traefik.http.services.${name}.loadbalancer.server.port" = "8080";
      };

      dependsOn = ["${name}-db"];
    };
  };
}
