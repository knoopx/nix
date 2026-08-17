{ lib
, ...
}:
with lib; let
  # Only the fields consumed by modules/home-manager/programs/pi-ai.nix
  # (the models.json "local" provider). No sampling/preset fields — the local
  # server is ninfer (hosts/desktop/containers/llm.nix) with its own flags.
  modelType = types.submodule {
    options = {
      id = mkOption {
        type = types.str;
        description = "Model identifier (public OpenAI model name)";
      };

      name = mkOption {
        type = types.str;
        description = "Display name";
      };

      family = mkOption {
        type = types.str;
        description = "Model family";
      };

      contextWindow = mkOption {
        type = types.int;
        default = 131072;
        description = "Context window size";
      };

      toolCall = mkOption {
        type = types.bool;
        default = true;
        description = "Support tool calling";
      };

      reasoning = mkOption {
        type = types.bool;
        default = true;
        description = "Support reasoning";
      };

      inputTypes = mkOption {
        type = types.listOf types.str;
        default = [ "text" ];
        description = "Input modalities";
      };

      outputTypes = mkOption {
        type = types.listOf types.str;
        default = [ "text" ];
        description = "Output modalities";
      };

      openWeights = mkOption {
        type = types.bool;
        default = true;
        description = "Open weights model";
      };

      releaseDate = mkOption {
        type = types.str;
        description = "Release date (ISO 8601)";
      };

      lastUpdated = mkOption {
        type = types.str;
        description = "Last updated date (ISO 8601)";
      };

      costInput = mkOption {
        type = types.float;
        default = 0.0;
        description = "Input cost per token";
      };

      costOutput = mkOption {
        type = types.float;
        default = 0.0;
        description = "Output cost per token";
      };

      costCacheRead = mkOption {
        type = types.float;
        default = 0.0;
        description = "Cache read cost per token";
      };

      costCacheWrite = mkOption {
        type = types.float;
        default = 0.0;
        description = "Cache write cost per token";
      };

      maxTokens = mkOption {
        type = types.int;
        default = 16384;
        description = "Maximum output tokens for PI agent";
      };

      compatSupportsDeveloperRole = mkOption {
        type = types.bool;
        default = true;
        description = "Compatibility: supports developer role";
      };

      compatMaxTokensField = mkOption {
        type = types.str;
        default = "max_tokens";
        description = "Compatibility: max tokens field name";
      };

      thinkingLevelMap = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = { };
        description = "Map PI thinking level (off/minimal/low/medium/high/xhigh/max) to the provider's reasoning_effort value; null disables that level.";
      };
    };
  };
in
{
  options.defaults.models = {
    local = mkOption {
      type = types.listOf modelType;
      description = "Local LLM model configurations";
    };

    cloud = mkOption {
      type = types.listOf types.str;
      description = "Cloud model identifiers (provider/model[:variant]) for settings.json enabledModels";
    };
  };

  config = {
    defaults.models.cloud = [
      "nvidia/nemotron-3-ultra-550b-a55b:free"
      "deepseek/deepseek-v4-flash"
      "tencent/hy3-preview"
      "xiaomi/mimo-v2.5"
      "stepfun/step-3.5-flash"
      "xiaomi/mimo-v2.5-pro"
      "minimax/minimax-m3"
      "qwen/qwen3.7-plus"
      "z-ai/glm-5.1"
    ];

    # Served locally by the ninfer container (hosts/desktop/containers/llm.nix).
    # `id` is the public OpenAI model name ninfer-serve advertises (--model-id);
    # weights are the volume-mounted .ninfer artifact neroued/Qwen3.8-27B-NInfer.
    defaults.models.local = [
      {
        id = "qwen3.8-27b";
        name = "Qwen3.8-27B";
        family = "qwen3.8";
        contextWindow = 131072;
        toolCall = true;
        reasoning = true;
        # Server runs without --vision: text in / text out.
        inputTypes = [ "text" ];
        releaseDate = "2026-08-15";
        lastUpdated = "2026-08-15";
        # Ninfer's chat template accepts none|low|medium|xhigh as distinct
        # reasoning_effort values. Null hides levels without a distinct mapping.
        thinkingLevelMap = {
          off = null;
          minimal = null;
          low = "low";
          medium = "medium";
          high = null;
          xhigh = "xhigh";
          max = null;
        };
      }
    ];
  };
}
