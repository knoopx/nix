{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.ai = {
    description = "AI configuration options";

    baseURL = mkOption {
      type = with types; nullOr str;
      description = "Base URL for the AI service.";
      default = "https://ai.${config.services.traefik-proxy.domain}";
    };

    mcp = mkOption {
      description = "AI MCP configuration";
      type = types.attrsOf (types.submodule {
        options = {
          command = mkOption {
            type = types.str;
            description = "Command to run the MCP.";
          };
          args = mkOption {
            type = types.listOf types.str;
            description = "Arguments for the MCP command.";
            default = [];
          };
          env = mkOption {
            type = types.attrsOf types.str;
            description = "Environment variables for the MCP.";
            default = {};
          };
          type = mkOption {
            type = with types; nullOr str;
            description = "Optional type for the MCP.";
            default = null;
          };
          url = mkOption {
            type = with types; nullOr str;
            description = "Optional URL for the MCP.";
            default = null;
          };
        };
      });
    };
    models = mkOption {
      description = "AI model configuration";
      type = types.attrsOf (types.submodule {
        options = {
          cmd = mkOption {
            type = types.str;
            description = "Command to run the model.";
          };
          unlisted = mkOption {
            type = types.bool;
            description = "Whether the model is unlisted.";
            default = false;
          };
          ttl = mkOption {
            type = with types; nullOr int;
            description = "Time-to-live for the model.";
            default = 60 * 5;
          };
          useModelName = mkOption {
            type = with types; nullOr str;
            description = "Override the model to be used.";
            default = null;
          };
          checkEndpoint = mkOption {
            type = with types; nullOr str;
            description = "Endpoint to check availability of the model.";
            default = null;
          };
          aliases = mkOption {
            type = types.listOf types.str;
            description = "Aliases for the model.";
            default = [];
          };

          context = mkOption {
            type = with types; nullOr int;
            description = "Context size for the model.";
            default = 0;
          };
        };
      });
    };
  };
}
