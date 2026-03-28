{pkgs, ...}: let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    n-gpu-layers = 999
    flash-attn = on
    models-max = 1
    no-mmap = true
    jinja = on
    cache-type-k = q8_0
    cache-type-v = q8_0
    ; speed up long-prefill workloads
    ;batch-size = 8192
    ;ubatch-size = 2048
    ; single-user agent workload: prioritize larger KV per model over parallel slots
    parallel = 1
    threads = 64
    ; each model section sets its own explicit ctx-size
    ctx-size = 0

    ; Qwen3-Coder-Next: 80B MoE, 3B active, non-thinking only
    ; Qwen recommended: temp=1.0, top_p=0.95, top_k=40, min_p=0.01
    ; UD-IQ3_XXS performs close to BF16 on Aider Polyglot (best bang/buck at 3-bit)
    ; CRITICAL: Re-download after Feb 19, 2026 update (llama.cpp key_gdiff bug fix)
    [unsloth/Qwen3-Coder-Next-GGUF]
    hf-repo = unsloth/Qwen3-Coder-Next-GGUF:UD-IQ3_XXS
    ctx-size = 65536:
    temp = 1.0
    top-p = 0.95
    top-k = 40
    min-p = 0.01

    ; Qwen3.5-35B-A3B: 35B MoE, 3B active
    ; Unsloth Dynamic quant
    ; Recommended coding mode: temp=0.6, top_p=0.95, top_k=20
    [unsloth/Qwen3.5-35B-A3B-GGUF]
    hf-repo = unsloth/Qwen3.5-35B-A3B-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-27B: 27B dense, strongest coder in family (72.4 SWE-bench)
    ; UD-Q4_K_XL: Unsloth Dynamic, important layers upcasted to 8/16-bit
    ; Recommended coding mode: temp=0.6, top_p=0.95, top_k=20
    [unsloth/Qwen3.5-27B-GGUF]
    hf-repo = unsloth/Qwen3.5-27B-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-v2: 27B dense reasoning model
    ; Distilled from Claude 4.6 Opus reasoning patterns
    ; Recommended: temp=0.7, top_p=0.9, top_k=40 for reasoning tasks
    [Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF]
    hf-repo = Jackrong/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-v2-GGUF:Q4_K_M
    ctx-size = 262144
    temp = 0.7
    top-p = 0.9
    top-k = 40
    min-p = 0.0
  '';
in {
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda";
      cmd = ["--models-preset" "/presets.ini" "--sleep-idle-seconds" "300"];
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
