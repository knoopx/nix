{config, ...}: {
  services.llama-swap = {
    enable = true;
    # https://github.com/mostlygeek/llama-swap/wiki/Configuration
    settings = {
      models = config.ai.models;
      groups = {
        forever = {
          persistent = true;
          swap = false;
          exclusive = false;
          members = ["whisper" "kokoro"];
        };
      };
    };
  };

  services.traefik-proxy = {
    hostServices = {
      ai = config.services.llama-swap.port;
    };
  };
}
