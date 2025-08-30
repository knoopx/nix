{
  pkgs,
  lib,
  nixosConfig,
  ...
}: let
  settingsFormat = pkgs.formats.json {};
in {
  xdg.configFile."opencode/agents".source = ./agents;

  xdg.configFile."opencode/config.json".source = settingsFormat.generate "config.json" {
    "$schema" = "https://opencode.ai/config.json";
    theme = "system";
    keybinds = {
      model_list = "ctrl+m";
    };
    mcp = {
      sequential-thinking = {
        type = "local";
        command = ["bunx" "@modelcontextprotocol/server-sequential-thinking"];
        enabled = true;
      };
      deepwiki = {
        type = "local";
        command = ["bunx" "mcp-deepwiki"];
        enabled = true;
      };
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        enabled = true;
      };
      github = {
        type = "local";
        command = ["podman" "run" "-i" "--rm" "-e" "GITHUB_PERSONAL_ACCESS_TOKEN" "ghcr.io/github/github-mcp-server"];
        enabled = true;
      };
      markitdown = {
        type = "local";
        command = ["uvx" "markitdown-mcp"];
        enabled = true;
      };
    };
    provider = {
      local = {
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "${nixosConfig.ai.baseURL}/v1";
        };
        models =
          builtins.mapAttrs
          (name: model: {
            id = model.id;
            reasoning = model.reasoning;
            tool_call = model.tool_call;
            limit = {
              context = model.context;
              output = 0;
            };
          })
          (lib.filterAttrs (name: model: model.unlisted != true) nixosConfig.ai.models);
      };
    };
  };
}
