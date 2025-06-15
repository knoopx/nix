_: {
  virtualisation.oci-containers.containers = {
    "paperless-ai" = {
      autoStart = true;
      image = "clusterzx/paperless-ai:latest";
      volumes = [
        "/mnt/storage/paperless-ai:/app/data"
      ];
    };
  };
}
