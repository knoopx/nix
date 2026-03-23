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
    batch-size = 8192
    ubatch-size = 2048
    ; single-user agent workload: prioritize larger KV per model over parallel slots
    parallel = 1
    threads = 64
    ; each model section sets its own explicit ctx-size
    ctx-size = 0

    ; GLM-4.7 Flash: 30B MoE (3B active), 200K context, MIT license
    ; 59.2% SWE-bench, 66.7% SWE-bench Multilingual, 41% Terminal-Bench 2.0
    ; UD-Q4_K_XL: 16.3GB, 37.80% HumanEval (best quant - Q5 performs worse!)
    ; Recommended by Z.AI: temp=1.0, top_p=0.95, top_k=40, min_p=0.01
    ; CRITICAL: repeat-penalty=1.0 or disabled to prevent looping (community-wide issue)
    [unsloth/GLM-4.7-Flash-GGUF]
    hf-repo = unsloth/GLM-4.7-Flash-GGUF:UD-Q4_K_XL
    ctx-size = 64000
    temp = 1.0
    top-p = 0.95
    top-k = 40
    min-p = 0.01
    repeat-penalty = 1.0

    ; Qwen3-Coder-Next: 80B MoE, 3B active, non-thinking only
    ; Qwen recommended: temp=1.0, top_p=0.95, top_k=40, min_p=0.01
    ; UD-IQ3_XXS performs close to BF16 on Aider Polyglot (best bang/buck at 3-bit)
    ; CRITICAL: Re-download after Feb 19, 2026 update (llama.cpp key_gdiff bug fix)
    [unsloth/Qwen3-Coder-Next-GGUF]
    hf-repo = unsloth/Qwen3-Coder-Next-GGUF:UD-IQ3_XXS
    ctx-size = 131072
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
    ctx-size = 131072
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-9B: small model
    ; At 9B, Q8 fits easily in VRAM for max quality
    ; Recommended general mode: temp=0.7, top_p=0.8, top_k=20
    [unsloth/Qwen3.5-9B-GGUF]
    hf-repo = unsloth/Qwen3.5-9B-GGUF:UD-Q8_K_XL
    ctx-size = 262144
    temp = 0.7
    top-p = 0.8
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-4B: small model
    [unsloth/Qwen3.5-4B-GGUF]
    hf-repo = unsloth/Qwen3.5-4B-GGUF:UD-Q8_K_XL
    ctx-size = 262144
    temp = 0.7
    top-p = 0.8
    top-k = 20
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
        "/home/knoopx/.cache/llama.cpp:/root/.cache/llama.cpp/"
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
