{pkgs, ...}: let
  root = "/mnt/storage/searxng";
in {
  virtualisation.oci-containers.containers.search = {
    autoStart = true;
    image = "searxng/searxng:latest";
    environment = {
      "SEARXNG_BASE_URL" = "https://search.knoopx.net";
      "UWSGI_THREADS" = "2";
      "UWSGI_WORKERS" = "2";
    };
    volumes = [
      "${root}:/etc/searxng:rw"
    ];

    environment = {
    };
  };
}
