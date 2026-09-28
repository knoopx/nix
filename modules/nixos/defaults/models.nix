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
        description = "Data type for the KV-cache storage";
      };

      spec = mkOption {
        type = types.nullOr types.str;
        default = "mtp";
        description = "Speculative decoding backend; null disables speculative decoding";
      };

      draftTokens = mkOption {
        type = types.int;
        default = 5;
        description = "Number of speculative draft tokens per step";
      };

      prefillChunk = mkOption {
        type = types.int;
        default = 4096;
        # default = 2048;
        # default = 1024;
        # default = 512;
        description = "Text-prefill chunk size in tokens";
      };

      lmHeadDraft = mkOption {
        type = types.bool;
        default = true;
        description = "Enable optimized LM-head draft proposal";
      };
    };
  };

  modelType = types.submodule {
    options = {
      id = mkOption {
        type = types.str;
        description = "Model identifier";
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
        # default = 262144; # C2
        default = 224531; # C3
        # default = 164,463; # C4
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
        description = "Release date";
      };

      lastUpdated = mkOption {
        type = types.str;
        description = "Last updated date";
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
        description = "Maximum output tokens";
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
        description = "Map PI thinking level to the provider's reasoning_effort_value; null disables that level.";
      };

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
        description = "Sampling temperature";
      };

      topP = mkOption {
        type = types.nullOr types.float;
        default = 0.95;
        description = "Top-p sampling";
      };

      topK = mkOption {
        type = types.nullOr types.int;
        default = 20;
        description = "Top-k sampling";
      };

      minP = mkOption {
        type = types.nullOr types.float;
        default = 0.0;
        description = "Min-p sampling";
      };

      presencePenalty = mkOption {
        type = types.nullOr types.float;
        default = 0.0;
        description = "Presence penalty";
      };

      repetitionPenalty = mkOption {
        type = types.nullOr types.float;
        default = 1.0;
        description = "Repetition penalty";
      };

      preserveThinking = mkOption {
        type = types.nullOr types.bool;
        default = true;
        description = "Retain thinking blocks across turns";
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
      description = "Cloud model identifiers for settings.json enabledModels";
    };

    localBaseUrl = mkOption {
      type = types.str;
      description = "Base URL of the local LLM engine for the pi agent's local provider";
    };
  };

  config = {
    defaults.models.localBaseUrl = "https://llm.knoopx.net";

    defaults.models.cloud = [
      "nvidia/nemotron-3-ultra-550b-a55b:free"
      "minimax/minimax-m3:free"
      "deepseek/deepseek-v4-flash-0731" # $0.05 / $0.16 per 1M
      "deepseek/deepseek-v4.1-flash" # 0.035 / $0.29 per 1M 
      "xiaomi/mimo-v2.5" # $0.119 / $0.238 per 1M
      "stepfun/step-3.5-flash" # $0.10 / $0.30 per 1M
      "xiaomi/mimo-v2.5-pro" # $0.3045 / $0.609 per 1M
      "qwen/qwen3.8-flash" # $0.15 / $0.47 per 1M
      "openai/gpt-5.6-luna" # $0.20 / $1.20 per 1M
      "openai/gpt-5.6-luna-pro" # $0.20 / $1.20 per 1M
      "z-ai/glm-5.3-flash" # $0.07125 / $0.2375 per 1M
      "z-ai/glm-5.2" # $0.4875 / $1.56 per 1M
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
          artifact = "ukisai/Swift-1.5-Qwen3.8-27b-nvfp4-w8g32-q4g64-q5g64-q6g64-bf16.v3.ninfer";
        };
      }

      {
        id = "neroued/Qwen3.8-27B-nvfp4-NInfer";
        name = "Qwen3.8-27B-nvfp4-NInfer";
        family = "qwen3.8";
        toolCall = true;
        inputTypes = [ "text" "image" ];
        releaseDate = "2026-08-15";
        lastUpdated = "2026-09-13";
        contextWindow = 150000;
        ninfer = {
          artifact = "neroued/Qwen3.8-27B-nvfp4-NInfer/qwen3_8_27b_nvfp4.ninfer";
        };
      }

      {
        id = "ornith-ai/Ornith-1.5-35B-A3B";
        name = "Ornith-1.5-35B-A3B";
        family = "qwen3.6";
        contextWindow = 262144;
        toolCall = true;
        reasoning = false;
        inputTypes = [ "text" "image" ];
        releaseDate = "2026-08-15";
        lastUpdated = "2026-08-18";
        ninfer = {
          artifact = "ornith-ai/Ornith-1.5-35B-A3B-MTP-w8g32-q4g64-q5g64-q6g64-bf16.v3.ninfer";
        };
      }
    ];
  };
}
