{ lib
, ...
}:
with lib; let
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

      hfRepo = mkOption {
        type = types.str;
        description = "Hugging Face repository with variant (e.g. repo:revision)";
      };

      contextWindow = mkOption {
        type = types.int;
        default = 128000;
        description = "Context window size";
      };

      ctk = mkOption {
        type = types.str;
        default = "q8_0";
        description = "Key cache type";
      };

      ctv = mkOption {
        type = types.str;
        default = "q8_0";
        description = "Value cache type";
      };

      temp = mkOption {
        type = types.float;
        default = 1.0;
        description = "Temperature";
      };

      topP = mkOption {
        type = types.float;
        default = 0.95;
        description = "Top-p sampling";
      };

      topK = mkOption {
        type = types.int;
        default = 0;
        description = "Top-k sampling (0 = disabled)";
      };

      minP = mkOption {
        type = types.float;
        default = 0.0;
        description = "Min-p sampling";
      };

      presencePenalty = mkOption {
        type = types.float;
        default = 0.0;
        description = "Presence penalty";
      };

      repeatPenalty = mkOption {
        type = types.float;
        default = 1.0;
        description = "Repeat penalty";
      };

      specDraftNMax = mkOption {
        type = types.int;
        default = 3;
        description = "Maximum speculative draft models";
      };

      specDraftPMin = mkOption {
        type = types.float;
        default = 0.85;
        description = "Minimum speculative draft probability";
      };

      parallel = mkOption {
        type = types.int;
        default = 1;
        description = "Number of parallel requests";
      };

      warmup = mkOption {
        type = types.bool;
        default = false;
        description = "Enable warmup run";
      };

      kvUnified = mkOption {
        type = types.bool;
        default = true;
        description = "Unified KV cache";
      };

      flashAttn = mkOption {
        type = types.bool;
        default = true;
        description = "Flash attention";
      };

      numGpuLayers = mkOption {
        type = types.str;
        default = "all";
        description = "Number of layers to offload to GPU";
      };

      specDraftNgl = mkOption {
        type = types.str;
        default = "all";
        description = "Speculative draft layers to offload";
      };

      mmap = mkOption {
        type = types.bool;
        default = false;
        description = "Enable memory-mapped I/O";
      };

      mlock = mkOption {
        type = types.bool;
        default = true;
        description = "Lock model in RAM";
      };

      batchSize = mkOption {
        type = types.int;
        default = 4096;
        description = "Batch size for generation";
      };

      ubatchSize = mkOption {
        type = types.int;
        default = 512;
        description = "Unbatched size";
      };

      specType = mkOption {
        type = types.str;
        default = "none";
        description = "Speculative decoding type (e.g. draft-mtp)";
      };

      toolCall = mkOption {
        type = types.bool;
        default = true;
        description = "Support tool calling";
      };

      reasoning = mkOption {
        type = types.bool;
        default = false;
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
        id = "bytkim/Qwen3.6-27B-MTP-pi-reasoning-GGUF";
        name = "bytkim/Qwen3.6-27B-MTP-pi-reasoning-GGUF";
        family = "qwen3.6";
        hfRepo = "bytkim/Qwen3.6-27B-MTP-pi-reasoning-GGUF:Q4_K_M";
        specType = "draft-mtp";
        releaseDate = "2026-06-21";
        lastUpdated = "2026-07-18";
      }
      {
        id = "bytkim/Qwen3.6-27B-MTP-pi-tune-GGUF";
        name = "bytkim/Qwen3.6-27B-MTP-pi-tune-GGUF";
        family = "qwen3.6";
        hfRepo = "bytkim/Qwen3.6-27B-MTP-pi-tune-GGUF:Q4_K_M";
        specType = "draft-mtp";
        releaseDate = "2026-06-21";
        lastUpdated = "2026-07-18";
      }
      {
        id = "protoLabsAI/ThinkingCap-Qwen3.6-27B-MTP-GGUF";
        name = "protoLabsAI/ThinkingCap-Qwen3.6-27B-MTP-GGUF";
        family = "qwen3.6";
        hfRepo = "protoLabsAI/ThinkingCap-Qwen3.6-27B-MTP-GGUF:NVFP4-MTP";
        specType = "draft-mtp";
        releaseDate = "2026-06-21";
        lastUpdated = "2026-07-18";
      }
      {
        id = "mudler/Qwen3.6-35B-A3B-APEX-MTP-GGUF";
        name = "mudler/Qwen3.6-35B-A3B-APEX-MTP-GGUF";
        family = "qwen3.6";
        hfRepo = "mudler/Qwen3.6-35B-A3B-APEX-MTP-GGUF:APEX-MTP-I-Quality";
        contextWindow = 262144;
        specType = "draft-mtp";
        releaseDate = "2026-04-14";
        lastUpdated = "2026-07-10";
      }
      {
        id = "gbuzhf/KAT-Coder-V2.5-Dev-MTP-GGUF";
        name = "gbuzhf/KAT-Coder-V2.5-Dev-MTP-GGUF";
        family = "qwen3.6";
        hfRepo = "gbuzhf/KAT-Coder-V2.5-Dev-MTP-GGUF:I-Balanced";
        specType = "draft-mtp";
        contextWindow = 262144;
        releaseDate = "2026-07-26";
        lastUpdated = "2026-07-27";
      }
    ];
  };
}
