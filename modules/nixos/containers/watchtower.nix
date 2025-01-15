_: {
  virtualisation.oci-containers.containers = {
    "watchtower" = {
      autoStart = true;
      image = "containrrr/watchtower";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      labels = {
        "traefik.enable" = "false";
      };
    };
  };
}
