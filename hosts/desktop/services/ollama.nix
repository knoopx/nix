{...}: {
  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
      host = "[::]";
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_CONTEXT_LENGTH = "8192";
      };
    };

    traefik-proxy = {
      hostServices = {
        ollama = 11434;
      };
    };
  };
}
