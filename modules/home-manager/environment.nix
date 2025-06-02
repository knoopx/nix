{defaults, ...}: {
  home.sessionVariables = {
    EDITOR = defaults.editor;
    AI_PROVIDER = "pollinations";
    OLLAMA_API_BASE = "http://127.0.0.1:11434";
    OPENAI_API_BASE = "https://text.pollinations.ai/openai";
    OPENAI_API_KEY = "pollinations";
  };
}
