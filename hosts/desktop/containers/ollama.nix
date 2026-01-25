{pkgs, ...}: let
  name = "ollama";
in {
  virtualisation.oci-containers.containers = {
    "${name}" = {
      autoStart = true;
      image = "ollama/ollama:latest";
      volumes = ["/home/knoopx/.ollama:/root/.ollama"];
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
        "--device=nvidia.com/gpu=all"
      ];
      ports = ["11434:11434"];
      environment = {
        OLLAMA_CUDA = "1";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_NUM_PARALLEL = "8";
        OLLAMA_MAX_LOADED_MODELS = "2";
        OLLAMA_MAX_QUEUE = "512";
      };
    };
  };
}
