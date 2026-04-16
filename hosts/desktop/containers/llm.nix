{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    flash-attn = on
    no-mmap = true
    jinja = on
    parallel = 1
    ;ctx-size = 0

    cache-type-k = q4_0
    cache-type-v = q4_0

    ;threads = 64
    ;batch-size = 16384
    ;ubatch-size = 8192

    ; Qwen3.5-27B: 27B dense, strongest coder in family (72.4 SWE-bench Verified)
    ; UD-Q5_K_XL: Unsloth Dynamic, important layers upcasted to 8/16-bit
    ; Official Qwen Team recommendation (HuggingFace model card):
    ; - Thinking mode for precise coding: temp=0.6, top_p=0.95, top_k=20, min_p=0.0
    ;   presence_penalty=0.0, repetition_penalty=1.0
    ; - Thinking mode for general tasks: temp=1.0, top_p=0.95, top_k=20, min_p=0.0
    ;   presence_penalty=1.5, repetition_penalty=1.0
    ; - Native context: 262,144 tokens (recommend at least 128K for thinking capabilities)
    ; - Output: 32K for most queries, 81K for complex problems
    ; --chat-template-kwargs '{"enable_thinking":false}'
    [unsloth/Qwen3.5-27B-GGUF]
    hf-repo = unsloth/Qwen3.5-27B-GGUF:UD-Q5_K_XL
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 0.0
    repeat-penalty = 1.0
    alias = gpt-3.5-turbo


    ; Qwen3.5-35B-A3B: 35B MoE, 3B active per token, 256K context
    ; Q5_K_M: imatrix quant, ~25GB
    [mradermacher/Qwen3.5-35B-A3B-i1-GGUF]
    hf-repo = mradermacher/Qwen3.5-35B-A3B-i1-GGUF:Q5_K_M
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-35B-A3B: 35B MoE, 3B active per token, 256K context
    ; IQ4_NL: IQ4_NL quantization, ~22GB
    [bartowski/Qwen3.5-35B-A3B-GGUF]
    hf-repo = bartowski/Qwen3.5-35B-A3B-GGUF:IQ4_NL
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.5-35B-A3B-APEX: 35B MoE with 3B active per token, 256K context
    ; APEX quantization (adaptive precision) for optimal quality/size ratio, ~20GB
    [mudler/Qwen3.5-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Qwen3.5-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    # top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwopus-MoE-35B-A3B-APEX: 35B MoE with APEX quantization
    [mudler/Qwopus-MoE-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Qwopus-MoE-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; LFM2-24B-A2B-APEX: 24B MoE with APEX quantization
    [mudler/LFM2-24B-A2B-APEX-GGUF]
    hf-repo = mudler/LFM2-24B-A2B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; GLM-4.7-Flash-APEX: Fast reasoning model with APEX quantization
    [mudler/GLM-4.7-Flash-APEX-GGUF]
    hf-repo = mudler/GLM-4.7-Flash-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Holo3-35B-A3B-APEX: 35B MoE with APEX quantization
    [mudler/Holo3-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Holo3-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3.6-35B-A3B: 35B MoE with 3B active per token, 256K context
    ; UD-Q5_K_XL: Unsloth Dynamic, important layers upcasted to 8/16-bit, ~26.6GB
    ; Official Qwen Team recommendation (HuggingFace model card):
    ; - Precise coding (e.g., WebDev): temp=0.6, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=0.0, repeat-penalty=1.0
    ; - General tasks: temp=1.0, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=1.5, repeat-penalty=1.0
    ; - Native context: 262,144 tokens (recommend at least 128K for thinking capabilities)
    ; - Output: 32K for most queries, 81K for complex problems
    ; - preserve_thinking: enabled for agent scenarios (maintains full reasoning context)
    [unsloth/Qwen3.6-35B-A3B-GGUF]
    hf-repo = unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q5_K_XL
    ctx-size = 262144
    temp = 1.0
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    
    ; Carnice-MoE-35B-A3B: 35B MoE with 3B active per token, 256K context
    ; APEX quantization (adaptive precision) for optimal quality/size ratio, ~20GB
    [mudler/Carnice-MoE-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Carnice-MoE-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Qwen3-Coder-Next: Next generation coding model
    [Qwen/Qwen3-Coder-Next]
    hf-repo = Qwen/Qwen3-Coder-Next
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
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
        # "--chat-template-kwargs"
        # "{\"enable_thinking\": false}"
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

