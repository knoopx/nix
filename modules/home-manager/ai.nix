{nixosConfig, ...}: {
  xdg.configFile."Code/User/mcp.json" = {
    text = builtins.toJSON {servers = nixosConfig.ai.mcp;};
  };

  xdg.configFile."Code/User/prompts/" = {
    source = ./ai/prompts;
    recursive = true;
  };
}
