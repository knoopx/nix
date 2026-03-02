{pkgs, ...}: let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    n-gpu-layers = 999
    flash-attn = on
    models-max = 1
    no-mmap = true
    jinja = on
    cont-batching = on
    cache-type-k = bf16
    cache-type-v = q8_0
    ctx-size = 0

    ; Qwen3-Coder-Next: 80B MoE, 3B active, non-thinking only
    ; Qwen recommended: temp=1.0, top_p=0.95, top_k=40, min_p=0.01
    ; UD-IQ3_XXS performs close to BF16 on Aider Polyglot (best bang/buck at 3-bit)
    [unsloth/Qwen3-Coder-Next-GGUF]
    model = Qwen3-Coder-Next-UD-IQ3_XXS.gguf
    temp = 1.0
    top-p = 0.95
    top-k = 40
    min-p = 0.01

    ; Qwen3.5-35B-A3B: 35B MoE, 3B active, hybrid thinking
    ; AesSedai Q4_K_M: lowest Mean KLD (0.0102) in community Q4 sweep
    ; Coding thinking mode: temp=0.6, top_p=0.95, top_k=20
    [AesSedai/Qwen3.5-35B-A3B-GGUF]
    model = Qwen3.5-35B-A3B-Q4_K_M.gguf
    mmproj = mmproj-Qwen3.5-35B-A3B-BF16.gguf
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-27B: 27B dense, strongest coder in family (72.4 SWE-bench)
    ; UD-Q4_K_XL: Unsloth Dynamic, important layers upcasted to 8/16-bit
    ; Coding thinking mode: temp=0.6, top_p=0.95, top_k=20
    [unsloth/Qwen3.5-27B-GGUF]
    model = Qwen3.5-27B-UD-Q4_K_XL.gguf
    mmproj = mmproj-BF16.gguf
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-9B: small model, thinking disabled by default
    ; At 9B, Q8 fits easily in VRAM for max quality
    ; Non-thinking general mode: temp=0.7, top_p=0.8, top_k=20
    [unsloth/Qwen3.5-9B-GGUF]
    model = Qwen3.5-9B-UD-Q8_K_XL.gguf
    mmproj = mmproj-BF16.gguf
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
