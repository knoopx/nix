{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    flash-attn = on
    no-mmap = true
    no-warmup = true
    jinja = on
    parallel = 1
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    # ctx-size = 131072

    [Qwen/Qwen3.6-27B]
    alias = Qwen3.6-27B
    hf-repo = unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL

    [Qwen/Qwen3.6-35B-A3B]
    alias = Qwen3.6-35B-A3B
    hf-repo = unsloth/Qwen3.6-35B-A3B-GGUF:Q4_K_XL

    [unsloth/embeddinggemma-300m-GGUF]
    alias = unsloth/embeddinggemma-300m-GGUF
    hf-repo = unsloth/embeddinggemma-300m-GGUF:Q4_0
    embedding = true
  '';
in
{
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda13";
      cmd = [
        "--models-preset"
        "/presets.ini"
        "--models-max"
        "2"
        "--sleep-idle-seconds"
        "300"
        "--reasoning-budget"
        "512"
        "--no-mmproj-offload"
        "--chat-template-file"
        "/chat_template.jinja"
        "--chat-template-kwargs"
        (builtins.toJSON {
          preserve_thinking = true;
        })
      ];
      ports = [
        "11434:8080"
      ];
      volumes = [
        "/home/knoopx/.cache/llama.cpp/:/root/.cache/llama.cpp/"
        "/home/knoopx/.cache/huggingface/:/root/.cache/huggingface/"
        "${presets}:/presets.ini:ro"
        "${./chat_template.jinja}:/chat_template.jinja:ro"
      ];
      extraOptions = [
        "--device=nvidia.com/gpu=all"
      ];
      labels = {
        "traefik.http.services.llm.loadbalancer.server.port" = "8080";
      };
    };
  };
}
