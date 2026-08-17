{ lib
, ...
}:
with lib; let
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

      ninferArtifact = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "ninfer artifact filename mounted in /models (hosts/desktop/containers/llm.nix); null = not served by ninfer";
      };

      ninferMaxConcurrency = mkOption {
        type = types.int;
        default = 2;
        description = "ninfer-serve --max-concurrency";
      };

      ninferKvCapacity = mkOption {
        type = types.str;
        default = "auto";
        description = "ninfer-serve --kv-capacity";
      };

      ninferKvDtype = mkOption {
        type = types.str;
        default = "int8";
        description = "ninfer-serve --kv-dtype";
      };

      ninferSpec = mkOption {
        type = types.nullOr types.str;
        default = "mtp";
        description = "ninfer-serve --spec (e.g. mtp); null disables";
      };

      ninferDraftTokens = mkOption {
        type = types.int;
        default = 5;
        description = "ninfer-serve --draft-tokens";
      };

      ninferDraftTokensMin = mkOption {
        type = types.int;
        default = 3;
        description = "ninfer-serve --draft-tokens-min";
      };

      ninferPrefillChunk = mkOption {
        type = types.int;
        default = 4096;
        description = "ninfer-serve --prefill-chunk";
      };

      ninferLmHeadDraft = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ninfer-serve --lm-head-draft";
      };

      ninferVision = mkOption {
        type = types.bool;
        default = true;
        description = "Enable ninfer-serve --vision";
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

    defaults.models.local = [
      {
        id = "ostfralla/Qwen3.8-27B";
        name = "Qwen3.8-27B";
        family = "qwen3.8";
        contextWindow = 131072;
        maxTokens = 16384;
        toolCall = true;
        inputTypes = [ "text" "image" ];
        ninferArtifact = "ostfralla/Qwen3.8-27B-NInfer-nvfp4-w8g32-q4g64-q5g64-q6g64-bf16.ninfer";
        releaseDate = "2026-08-15";
        lastUpdated = "2026-08-18";
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
      {
        id = "ornith-ai/Ornith-1.5-35B-A3B";
        name = "Ornith-1.5-35B-A3B";
        family = "qwen3.6";
        contextWindow = 262144;
        maxTokens = 16384;
        toolCall = true;
        reasoning = false;
        inputTypes = [ "text" ];
        ninferArtifact = "ornith-ai/Ornith-1.5-35B-A3B-MTP-w8g32-q4g64-q5g64-q6g64-bf16.ninfer";
        releaseDate = "2026-08-15";
        lastUpdated = "2026-08-18";
      }
    ];
  };
}
