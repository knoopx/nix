{
  pkgs,
  lib,
  nixosConfig,
  ...
}: let
  settingsFormat = pkgs.formats.json {};
in {
  xdg.configFile."opencode/config.json".source = settingsFormat.generate "config.json" {
    "$schema" = "https://opencode.ai/config.json";
    theme = "system";
    mcp = {
      sequential-thinking = {
        type = "local";
        command = ["bunx" "@modelcontextprotocol/server-sequential-thinking"];
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
