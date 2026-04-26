{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    flash-attn = on
    no-mmap = true
    mlock = true
    no-warmup = true
    kv-unified = true
    jinja = on
    parallel = 1

    threads = 64
    prio = 2
 
    cache-type-k = q4_0
    cache-type-v = q4_0

    batch-size = 4096
    ubatch-size = 2048

    [unsloth/Qwen3.6-27B-GGUF]
    hf-repo = unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    alias = gpt-3.5-turbo

    [AesSedai/Qwen3.6-35B-A3B-GGUF]
    hf-repo = AesSedai/Qwen3.6-35B-A3B-GGUF:Q5_K_M
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    override-tensor = blk\.(3[5-9])\.ffn_.*_exps.*=CPU
  '';
in
{
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda";
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
