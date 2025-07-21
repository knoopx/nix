{
  pkgs,
  lib,
  ...
}: let
  llamaServer = {
    name,
    context,
    args,
  }: {
    context = context;
    cmd = ''
      ${pkgs.podman}/bin/podman run --rm --name llama-server --device=nvidia.com/gpu=all --ipc=host -p ''${PORT}:8080 \
        -v /var/cache/llama.cpp/:/root/.cache/llama.cpp/ \
        ghcr.io/ggml-org/llama.cpp:server-cuda \
        -hf ${name} --ctx-size ${toString context} \
        ${lib.concatStringsSep " " args}
    '';
  };
in {
  ai = {
    models = {
      "qwq-32b" = llamaServer {
        name = "bartowski/Qwen_QwQ-32B-GGUF:IQ4_NL";
        context = 32768;
        args = [
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--jinja"
          "--metrics"
          "--min-p 0.01"
          "--no-context-shift"
          "--no-mmap"
          "--reasoning-format deepseek"
          "--samplers top_k;top_p;min_p;temperature;dry;typ_p;xtc"
          "--slots"
          "--temp 0.6"
          "--top-k 40"
          "--top-p 0.95"
          "-ngl 99"
        ];
      };
      "qwen2.5-coder" = llamaServer {
        name = "bartowski/Qwen2.5-Coder-32B-Instruct-GGUF:IQ4_NL";
        context = 32768;
        args = [
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--jinja"
          "--metrics"
          "--min-p 0.01"
          "--no-context-shift"
          "--no-mmap"
          "--slots"
          "--temp 0.6"
          "--top-k 40"
          "--top-p 0.95"
          "-ngl 99"
        ];
      };

      "qwen3-14b" = llamaServer {
        name = "unsloth/Qwen3-14B-GGUF:IQ4_NL";
        context = 32768;
        args = [
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--jinja"
          "--metrics"
          "--min-p 0"
          "--no-context-shift"
          "--no-mmap"
          "--reasoning-format deepseek"
          "--slots"
          "--temp 0.6"
          "--top-k 20"
          "--top-p 0.95"
          "-ngl 99"
        ];
      };

      "devstral" = llamaServer {
        name = "unsloth/Devstral-Small-2507-GGUF:IQ4_NL";
        context = 128000;
        args = [
          "--jinja"
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--no-context-shift"
          "--no-mmap"
          "--slots"
          "-ngl 75"
        ];
      };

      "codegeex4-9b" = llamaServer {
        name = "bartowski/codegeex4-all-9b-GGUF:Q8_0";
        context = 131072;
        args = [
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--flash-attn"
          "--jinja"
          "--metrics"
          "--min-p 0.01"
          "--no-context-shift"
          "--no-mmap"
          "--reasoning-format deepseek"
          "--slots"
          "--temp 0.6"
          "--top-k 40"
          "--top-p 0.95"
          "-ngl 99"
        ];
      };

      "qwen3-32b" = llamaServer {
        name = "unsloth/Qwen3-32B-GGUF:IQ4_NL";
        context = 40960;
        args = [
          "--jinja"
          "--color"
          "-ngl 99"
          "-fa"
          "-sm row"
          "--temp 0.6"
          "--top-k 20"
          "--top-p 0.95"
          "--min-p 0"
          "--presence-penalty 1.5"
          "-n 32768"
          "--no-context-shift"
        ];
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
}
