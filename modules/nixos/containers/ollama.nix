{...}: let
  dataDir = "/var/lib/ollama/";
in {
  virtualisation.oci-containers.containers.ollama = {
    image = "ollama/ollama";
    ports = ["11434:11434"];
    volumes = ["${dataDir}:/root/.ollama"];
    extraOptions = [
      "--device"
      "nvidia.com/gpu=all"
    ];
    environment = {
      OLLAMA_FLASH_ATTENTION = "1";
    };
    labels = {
      "traefik.enable" = "false";
    };
  };
}
