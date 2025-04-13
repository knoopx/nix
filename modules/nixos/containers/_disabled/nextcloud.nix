{...}: let
  root = "/mnt/storage/nextcloud";
in {
  virtualisation.oci-containers.containers = {
    nextcloud = {
      autoStart = true;
      image = "nextcloud/all-in-one:latest";
      ports = ["80:80" "8080:8080" "8443:8443"];
      volumes = [
        # "${root}:/mnt/docker-aio-config"
        "nextcloud_aio_mastercontainer:/mnt/docker-aio-config"
        "//var/run/docker.sock:/var/run/docker.sock:ro"
      ];
    };
  };
}
