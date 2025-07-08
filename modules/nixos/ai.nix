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

    instructions = {
      commit = mkOption {
        type = with types; nullOr path;
        description = "Path to commit message instructions file for the AI service.";
        default = null;
      };
      code = mkOption {
        type = with types; nullOr (listOf path);
        description = "List of paths to code generation instructions files for the AI service.";
        default = null;
      };
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
            default = 8192;
          };
        };
      });
    };
  };

  config = {
    ai = {
      instructions = {
        commit = ./ai/instructions/commit.md;
        code = [
          ./ai/instructions/code/general.instructions.md
          ./ai/instructions/code/ruby.instructions.md
          ./ai/instructions/code/python.instructions.md
          ./ai/instructions/code/nix.instructions.md
          ./ai/instructions/code/javascript.instructions.md
        ];
      };
      # https://github.com/aidan-labs/stt-tts-agent/
      models = {
        # ${pkgs.llama-cpp}/bin/llama-server -hf unsloth/gemma-3n-E4B-it-GGUF:Q8_0 --port ''${PORT}
        # # vllm serve "unsloth/Qwen3-14B-GGUF"
        # --host 127.0.0.1 --port 9503 --flash-attn --metrics--slots
        # --cache-type-k q8_0 --cache-type-v q8_0
        # --ctx-size 32000
        # --samplers "top_k;top_p;min_p;temperature;dry;typ_p;xtc"
        # --temp 0.6 --repeat-penalty 1.1 --dry-multiplier 0.5
        # --min-p 0.01 --top-k 40 --top-p 0.95
        # -ngl 99
        # --model /mnt/nvme/models/bartowski/Qwen_QwQ-32B-Q4_K_M.gguf

        # "qwen/qwen3-30b-a3b"
        "qwen3-14b" = {
          # ${pkgs.llama-cpp}/bin/llama-server \
          cmd = ''
            ${pkgs.docker}/bin/docker run --rm --device=nvidia.com/gpu=all \
              -p ''${PORT}:8080 \
              -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
              ghcr.io/ggml-org/llama.cpp:server-cuda \
              -hf unsloth/Qwen3-14B-GGUF:Q8_0 \
              --flash-attn --metrics --slots \
              --cache-type-k q8_0 --cache-type-v q8_0 \
              --ctx-size 32000 --no-context-shift \
              --temp 0.6 --min-p 0 \
              --top-k 20 --top-p 0.95 -ngl 99 \
              --jinja --reasoning-format deepseek \
              --no-mmap
          '';
        };

        # docker run --device=nvidia.com/gpu=all \
        #   -v /var/cache/huggingface:/root/.cache/huggingface \
        #   -p 8000:8000 \
        #   --ipc=host \
        #   vllm/vllm-openai:latest \
        #   --model mistralai/Mistral-7B-v0.1
        "kokoro" = {
          unlisted = true;
          cmd = ''
            ${pkgs.docker}/bin/docker run --device=nvidia.com/gpu=all -p ''${PORT}:8880 ghcr.io/remsky/kokoro-fastapi-gpu:latest
          '';
          # useModelName = "kokoro";
          aliases = [
            "tts-1"
          ];
        };
        # "whisper" = {
        #   unlisted = true;
        #   checkEndpoint = "/v1/audio/transcriptions/";
        #   cmd = let
        #     whisper-large-v3-turbo = pkgs.fetchurl {
        #       url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo-q8_0.bin";
        #       sha256 = "sha256-MX62nBFnPJ3h4fDUWbJTmZgE7HGsTCPBfs9fviTiWaE=";
        #     };
        #   in ''
        #     ${pkgs.docker}/bin/docker run --device=nvidia.com/gpu=all -p ''${PORT}:8080 \
        #         -v ${whisper-large-v3-turbo}:/models/ggml-large-v3-turbo-q8_0.bin \
        #         ghcr.io/ggml-org/whisper.cpp:main-cuda 'whisper-server --model /models/ggml-large-v3-turbo-q8_0.bin --request-path /v1/audio/transcriptions --inference-path ""'
        #   '';
        # };
      };

      mcp = {
        "deepwiki" = {
          "command" = "bunx";
          "args" = ["mcp-deepwiki"];
        };

        "markitdown" = {
          "command" = "uvx";
          "args" = ["markitdown-mcp"];
        };

        "nixos" = {
          "command" = "uvx";
          "args" = ["mcp-nixos"];
        };

        # "github" = {
        #   "command" = "docker";
        #   "args" = [
        #     "run"
        #     "-i"
        #     "--rm"
        #     "-e"
        #     "GITHUB_PERSONAL_ACCESS_TOKEN"
        #     "ghcr.io/github/github-mcp-server"
        #   ];
        #   "env" = {
        #     "GITHUB_PERSONAL_ACCESS_TOKEN" = "\${GITHUB_TOKEN}";
        #   };
        # };

        # "huggingface" = {
        #   "command" = "uvx";
        #   "args" = ["huggingface-mcp-server"];
        # };

        # console-ninja = {
        #   command = "npx";
        #   args = [
        #     "-y"
        #     "-c"
        #     "node ~/.console-ninja/mcp/"
        #   ];
        # };

        # context7 = {
        #   type = "http";
        #   url = "https://mcp.context7.com/mcp";
        # };

        # "playwright" = {
        #   "command" = "bunx";
        #   "args" = [" @playwright/mcp@latest"];
        # };

        # puppeteer = {
        #   command = "${pkgs.nodejs}/bin/npx";
        #   args = ["-y" "@modelcontextprotocol/server-puppeteer"];
        # };

        # "duckdb" = {
        #   "command" = "uvx";
        #   "args" = ["mcp-server-duckdb"];
        # };    };
      };
    };
  };
}
