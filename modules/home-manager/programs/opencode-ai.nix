{
  pkgs,
  nixosConfig,
  ...
}: let
  settingsFormat = pkgs.formats.json {};
in {
  xdg.configFile."opencode/config.json".source = settingsFormat.generate "config.json" {
    "$schema" = "https://opencode.ai/config.json";
    theme = "system";
    mcp = {
      # TODO
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
          nixosConfig.ai.models;
      };
    };
  };
}
