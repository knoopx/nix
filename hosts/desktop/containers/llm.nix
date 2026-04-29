{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    # flash-attn = on
    # no-mmap = true
    ngl = 999
    no-warmup = true
    jinja = on
    parallel = 1

    # threads = 64
    # prio = 2

    cache-type-k = q4_0
    cache-type-v = q4_0

    # batch-size = 4096
    # ubatch-size = 2048

    [Qwen/Qwen3.6-27B]
    alias = Qwen3.6-27B
    hf-repo = unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL
    # hf-repo = Freenixi/Abiray-Qwen3.6-27B-NVFP4-GGUF:NVFP4
    # hf-repo = DavidAU/Qwen3.6-27B-NEO-CODE-Di-IMatrix-MAX-GGUF:Q5_K_M
    ctx-size = 262144
    temp = 0.8
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0

    [Qwen/Qwen3.6-35B-A3B]
    alias = Qwen3.6-35B-A3B
    # hf-repo = AesSedai/Qwen3.6-35B-A3B-GGUF:Q5_K_M
    hf-repo = unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_XL
    # hf-repo = knoopx/Qwen3.6-35B-A3B-NVFP4-GGUF
    ctx-size = 262144
    temp = 0.8
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    # override-tensor = blk\.(3[5-9])\.ffn_.*_exps.*=CPU
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
        "1"
        "--sleep-idle-seconds"
        "300"
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
