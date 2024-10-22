{...}: let
  name = "open-webui";
in {
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;

      image = "ghcr.io/open-webui/open-webui";

      volumes = [
        "${name}:/app/backend/data"
      ];
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
        # "--gpus all"
      ];
      environment = {
        "OLLAMA_BASE_URL" = "http://host.docker.internal:11434";
      };
    };
  };
}
