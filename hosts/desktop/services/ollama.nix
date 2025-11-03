{...}: {
  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
      host = "[::]";
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_CONTEXT_LENGTH = toString (1024 * 32);
      };
    };

    traefik-proxy = {
      hostServices = {
        ollama = 11434;
      };
    };
  };
}
