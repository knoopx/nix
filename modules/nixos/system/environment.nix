{defaults, ...}: {
  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    sessionVariables = {
      EDITOR = defaults.editor;
      AI_PROVIDER = "pollinations";
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      OPENAI_API_BASE = "https://text.pollinations.ai/openai";
      OPENAI_API_KEY = "pollinations";
    };
  };
}
