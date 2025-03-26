{pkgs, ...}: let
  root = "/mnt/storage/searxng";
in {
  services.searx = {
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

  # virtualisation.oci-containers.containers.search = {
  #   autoStart = true;
  #   image = "searxng/searxng:latest";
  #   environment = {
  #     "SEARXNG_BASE_URL" = "https://search.knoopx.net";
  #     "UWSGI_THREADS" = "2";
  #     "UWSGI_WORKERS" = "2";
  #   };
  #   volumes = [
  #     "${root}:/etc/searxng:rw"
  #   ];

  #   environment = {
  #   };
  # };
}
