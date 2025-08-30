{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.defaults = {
    ai = {
      description = "AI configuration options";
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
            id = mkOption {
              type = with types; nullOr str;
              description = "Unique identifier for the model.";
              default = null;
            };
            cmd = mkOption {
              type = types.str;
              description = "Command to run the model.";
            };
            reasoning = mkOption {
              type = types.bool;
              description = "Whether the model supports reasoning.";
              default = false;
            };
            tool_call = mkOption {
              type = types.bool;
              description = "Whether the model supports tools.";
              default = false;
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
  };

  config = {
    defaults = {
      ai = {
        mcp = {
          sequential-thinking = {
            command = "bunx";
            args = ["@modelcontextprotocol/server-sequential-thinking"];
          };

          deepwiki = {
            command = "bunx";
            args = ["mcp-deepwiki"];
          };

          markitdown = {
            command = "uvx";
            args = ["markitdown-mcp"];
          };

          nixos = {
            command = "uvx";
            args = ["mcp-nixos"];
          };

          # {
          # 	"gallery": true,
          # 	"inputs": [
          # 		{
          # 			"name": "memory_file_path",
          # 			"type": "promptString",
          # 			"description": "Path to the memory storage file (optional)",
          # 			"password": false
          # 		}
          # 	],
          # 	"command": "npx",
          # 	"args": [
          # 		"-y",
          # 		"@modelcontextprotocol/server-memory"
          # 	],
          # 	"env": {
          # 		"MEMORY_FILE_PATH": "${input:memory_file_path}"
          # 	}
          # }

          # memory = {
          #   inputs = [
          #     {
          #       name = "memory_file_path";
          #       type = "promptString";
          #       description = "Path to the memory storage file (optional)";
          #       password = false;
          #     }
          #   ];
          #   command = "bunx";
          #   args = ["@modelcontextprotocol/server-memory"];
          #   env = {
          #     MEMORY_FILE_PATH = "''${input:memory_file_path}";
          #   };
          # };

          # playwright = {
          #   command = "bunx";
          #   args = [" @playwright/mcp@latest"];
          # };

          # context7 = {
          #   type = "http";
          #   url = "https://mcp.context7.com/mcp";
          # };

          # github = {
          #   command = "podman";
          #   args = [
          #     "run"
          #     "-i"
          #     "--rm"
          #     "-e"
          #     "GITHUB_PERSONAL_ACCESS_TOKEN"
          #     "ghcr.io/github/github-mcp-server"
          #   ];
          #   env = {
          #     GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_TOKEN}";
          #   };
          # };

          # huggingface = {
          #   command = "uvx";
          #   args = ["huggingface-mcp-server"];
          # };

          # console-ninja = {
          #   command = "npx";
          #   args = [
          #     "-y"
          #     "-c"
          #     "node ~/.console-ninja/mcp/"
          #   ];
          # };

          # puppeteer = {
          #   command = "${pkgs.nodejs}/bin/npx";
          #   args = ["-y" "@modelcontextprotocol/server-puppeteer"];
          # };

          # duckdb = {
          #   command = "uvx";
          #   args = ["mcp-server-duckdb"];
          # };
        };
        models = {
          "qwen2.5-coder" = {
            id = "qwen2.5-coder";
            context = 32768;
            reasoning = false;
            tool_call = false;
            cmd = ''
              ${pkgs.podman}/bin/podman run --rm --name llama-server --replace --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
                -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
                ghcr.io/ggml-org/llama.cpp:server-cuda \
                -hf bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:IQ4_NL --ctx-size 32768 \
                --cache-type-k q8_0 --cache-type-v q8_0 --flash-attn --jinja --metrics --top-k 40 --top-p 0.95 --temp 0.6 --threads -1 -ngl 99
            '';
          };

          "qwen/qwen3-30b-a3b-instruct-2507" = {
            id = "qwen/qwen3-30b-a3b-instruct-2507";
            context = 64000;
            reasoning = true;
            tool_call = true;
            cmd = ''
              ${pkgs.podman}/bin/podman run --rm --name llama-server --replace --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
                -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
                ghcr.io/ggml-org/llama.cpp:server-cuda \
                -hf unsloth/Qwen3-Coder-30B-A3B-Instruct-1M-GGUF:IQ4_NL --ctx-size 64000 \
                --cache-type-k q8_0 --cache-type-v q8_0 --flash-attn --jinja --metrics --min-p 0.01 --no-context-shift --no-mmap --reasoning-format deepseek --slots --temp 0.6 --top-k 40 --top-p 0.95 -ngl 99
            '';
          };

          "openai/gpt-oss-20b" = {
            id = "openai/gpt-oss-20b";
            context = 64000;
            reasoning = true;
            tool_call = true;
            cmd = ''
              ${pkgs.podman}/bin/podman run --rm --name llama-server --replace --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
                -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
                ghcr.io/ggml-org/llama.cpp:server-cuda \
                -hf unsloth/gpt-oss-20b-GGUF --ctx-size 64000 \
                --cache-type-k q8_0 --cache-type-v q8_0 --flash-attn --jinja --metrics --top-k 40 --top-p 0.95 --temp 0.6 --threads -1 -ngl 99
            '';
          };

          "google/gemma-3n-e4b-it" = {
            id = "google/gemma-3n-e4b-it";
            context = 32768;
            reasoning = false;
            tool_call = false;
            cmd = ''
              ${pkgs.podman}/bin/podman run --rm --name llama-server --replace --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
                -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
                ghcr.io/ggml-org/llama.cpp:server-cuda \
                -hf unsloth/gemma-3n-E4B-it-GGUF:F16 --ctx-size 32768 \
                --cache-type-k q8_0 --cache-type-v q8_0 --flash-attn --jinja --metrics --top-k 40 --top-p 0.95 --temp 0.6 --threads -1 -ngl 99
            '';
          };

          "kokoro" = {
            unlisted = true;
            cmd = ''
              ${pkgs.podman}/bin/podman run --rm --name kokoro --device=nvidia.com/gpu=all -p ''${PORT}:8880 ghcr.io/remsky/kokoro-fastapi-gpu:latest
            '';
            aliases = [
              "tts-1"
            ];
          };
        };
      };
    };
  };
}
