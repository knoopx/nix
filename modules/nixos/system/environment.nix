{
  pkgs,
  defaults,
  ...
}: {
  environment = {
    variables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      GSK_RENDERER = "ngl";
    };

    sessionVariables = {
      EDITOR = defaults.editor;
      AI_PROVIDER = "pollinations";
      OLLAMA_API_BASE = "http://127.0.0.1:11434";
      OPENAI_API_BASE = "https://text.pollinations.ai/openai";
      OPENAI_API_KEY = "pollinations";

      # expose python with common packages
      PYTHONPATH = "${pkgs.python312.withPackages (ps:
        with ps; [
          numpy
          torch
          requests
          pillow
        ])}/${pkgs.python312.sitePackages}";
    };
  };
}
