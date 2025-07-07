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
      # TODO
    };
    provider = {
      "google-cloud-code" = {
        name = "Google Cloud Code";
        doc = "https://github.com/aryasaatvik/cloud-code-ai-provider";
        npm = "cloud-code-ai-provider";
        models = {
          "gemini-2.5-pro" = {
            id = "gemini-2.5-pro";
            name = "Gemini 2.5 Pro";
            attachment = true;
            reasoning = true;
            temperature = true;
            tool_call = true;
            knowledge = "2025-01";
            release_date = "2025-03-20";
            last_updated = "2025-06-05";
            modalities = {
              input = ["text" "image" "audio" "video" "pdf"];
              output = ["text"];
            };
            open_weights = false;
            cost = {
              input = 1.25;
              output = 10;
              cache_read = 0.31;
            };
            limit = {
              context = 1048576;
              output = 65536;
            };
          };
          "gemini-2.5-flash" = {
            id = "gemini-2.5-flash";
            name = "Gemini 2.5 Flash";
            attachment = true;
            reasoning = true;
            temperature = true;
            tool_call = true;
            knowledge = "2025-01";
            release_date = "2025-03-20";
            last_updated = "2025-06-05";
            modalities = {
              input = ["text" "image" "audio" "video" "pdf"];
              output = ["text"];
            };
            open_weights = false;
            cost = {
              input = 0.3;
              output = 2.5;
              cache_read = 0.075;
            };
            limit = {
              context = 1048576;
              output = 65536;
            };
          };
        };
      };
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
