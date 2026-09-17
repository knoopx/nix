{ lib
, ...
}:
with lib; let
  ninferType = types.submodule {
    options = {
      artifact = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "NInfer artifact filename to mount into the /models volume; null = model not served by the NInfer engine";
      };

      kvCapacity = mkOption {
        type = types.str;
        default = "auto";
        description = "KV-cache capacity for this model's engine; \"auto\" sizes it from available GPU memory";
      };

      kvDtype = mkOption {
        type = types.str;
        default = "int8";
        # default = "nvfp4";
        # default = "k8v4";
        description = "Data type for the KV-cache storage (int8, nvfp4, k8v4, etc.)";
      };

      spec = mkOption {
        type = types.nullOr types.str;
        default = "mtp";
        description = "Speculative decoding backend (e.g. mtp, dflash2); null disables speculative decoding";
      };

      draftTokens = mkOption {
        type = types.int;
        default = 4;
        description = "Number of speculative draft tokens per step (only used when spec is set)";
      };

      prefillChunk = mkOption {
        type = types.int;
        default = 4096;
        # default = 2048;
        # default = 1024;
        # default = 512;
        description = "Text-prefill chunk size in tokens (larger = faster prefill but more memory)";
      };

      lmHeadDraft = mkOption {
        type = types.bool;
        default = true;
        description = "Enable optimized LM-head draft proposal (only used when spec is set)";
      };
    };
  };

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
        default = 200000;
        description = "Context window size (Qwen3.8-27B recommended inference default: 262144)";
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
        default = 32768;
        # default = 16384;
        # default = 24480;
        description = "Maximum output tokens for PI agent (Qwen3.8-27B recommended inference default: 131072)";
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
        default = {
          off = null;
          minimal = null;
          low = "low";
          medium = "medium";
          high = null;
          xhigh = "xhigh";
          max = null;
        };
        description = "Map PI thinking level (off/minimal/low/medium/high/xhigh/max) to the provider's reasoning_effort_value; null disables that level.";
      };

      # Engine-specific options: nested per engine. A model uses only the block(s) it needs;
      # the other engine block stays `{}` (all its sub-options resolve to their null/neutral defaults).
      ninfer = mkOption {
        type = ninferType;
        default = { };
        description = "NInfer engine-specific options; emitted per model into the serve config JSON";
      };

      maxConcurrency = mkOption {
        type = types.nullOr types.int;
        default = 3;
        description = "Max concurrent requests";
      };

      temperature = mkOption {
        type = types.nullOr types.float;
        default = 1.0;
        description = "Sampling temperature (Qwen3.8-27B recommended inference default: 1.0 thinking / 0.7 instruct)";
      };

      topP = mkOption {
        type = types.nullOr types.float;
        default = 0.95;
        description = "Top-p sampling (Qwen3.8-27B recommended inference default: 0.95 thinking / 0.80 instruct)";
      };

      topK = mkOption {
        type = types.nullOr types.int;
        default = 20;
        description = "Top-k sampling (Qwen3.8-27B recommended inference default: 20)";
      };

      minP = mkOption {
        type = types.nullOr types.float;
        default = 0.0;
        description = "Min-p sampling (Qwen3.8-27B recommended inference default: 0.0)";
      };

      presencePenalty = mkOption {
        type = types.nullOr types.float;
        default = 0.0;
        description = "Presence penalty (Qwen3.8-27B recommended inference default: 0.0 thinking / 1.5 instruct)";
      };

      repetitionPenalty = mkOption {
        type = types.nullOr types.float;
        default = 1.0;
        description = "Repetition penalty (Qwen3.8-27B recommended inference default: 1.0)";
      };

      preserveThinking = mkOption {
        type = types.nullOr types.bool;
        default = true;
        description = "Retain thinking blocks across turns (Qwen3.8-27B HF model card: enabled by default)";
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
      "minimax/minimax-m3:free"
      "deepseek/deepseek-v4-flash-0731" # $0.05 / $0.16per 1M
      "xiaomi/mimo-v2.5" # $0.119 / $0.238per 1M
      "stepfun/step-3.5-flash" # $0.10 / $0.30per 1M
      "xiaomi/mimo-v2.5-pro" # $0.3045 / $0.609per 1M
      "qwen/qwen3.8-flash" # $0.15 / $0.47per 1M
      "openai/gpt-5.6-luna" # $0.20 / $1.20per 1M
      "openai/gpt-5.6-luna-pro:nitro" # $0.20 / $1.20per 1M
      "z-ai/glm-5.3-flash" # $0.07125 / $0.2375per 1M
      "z-ai/glm-5.2" # $0.4875 / $1.56per 1M
    ];

    defaults.models.local = [
      {
        id = "ukisai/Swift-Qwen3.8-27B";
        name = "Swift-Qwen3.8-27B";
        family = "qwen3.8";
        toolCall = true;
        inputTypes = [ "text" "image" ];
        releaseDate = "2026-08-15";
        lastUpdated = "2026-09-13";
        ninfer = {
          artifact = "ukisai/Swift-Qwen3.8-27b-nvfp4-w8g32-q4g64-q5g64-q6g64-bf16.v3.ninfer";
        };
      }

      {
        id = "ostfralla/Qwen3.8-27B";
        name = "Qwen3.8-27B";
        family = "qwen3.8";
        toolCall = true;
        inputTypes = [ "text" "image" ];
        releaseDate = "2026-08-15";
        lastUpdated = "2026-08-18";
        ninfer = {
          artifact = "ostfralla/Qwen3.8-27B-NInfer-nvfp4-w8g32-q4g64-q5g64-q6g64-bf16.v3.ninfer";
        };
      }

      {
        id = "ornith-ai/Ornith-1.5-35B-A3B";
        name = "Ornith-1.5-35B-A3B";
        family = "qwen3.6";
        contextWindow = 262144;
        toolCall = true;
        reasoning = false;
        inputTypes = [ "text" ];
        releaseDate = "2026-08-15";
        lastUpdated = "2026-08-18";
        ninfer = {
          artifact = "ornith-ai/Ornith-1.5-35B-A3B-MTP-w8g32-q4g64-q5g64-q6g64-bf16.v3.ninfer";
        };
      }
    ];
  };
}
