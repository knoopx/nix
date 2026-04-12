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

    ; Qwen3.5-27B: 27B dense, strongest coder in family (72.4 SWE-bench Verified)
    ; UD-Q4_K_XL: Unsloth Dynamic, important layers upcasted to 8/16-bit
    ; Official Qwen Team recommendation (HuggingFace model card):
    ; - Thinking mode for precise coding: temp=0.6, top_p=0.95, top_k=20, min_p=0.0
    ;   presence_penalty=0.0, repetition_penalty=1.0
    ; - Thinking mode for general tasks: temp=1.0, top_p=0.95, top_k=20, min_p=0.0
    ;   presence_penalty=1.5, repetition_penalty=1.0
    ; - Native context: 262,144 tokens (recommend at least 128K for thinking capabilities)
    ; - Output: 32K for most queries, 81K for complex problems
    ; --chat-template-kwargs '{"enable_thinking":false}'
    [unsloth/Qwen3.5-27B-GGUF]
    hf-repo = unsloth/Qwen3.5-27B-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 1.0
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 0.0
    repeat-penalty = 1.0
    alias = gpt-3.5-turbo

    ; Qwopus3.5-27B-v3: 27B dense, reasoning-enhanced Qwen3.5-27B
    ; Act-then-refine paradigm, optimized for tool-calling and coding (95.73% HumanEval)
    ; Official Qwen Team recommendation (HuggingFace model card):
    ; - Thinking mode for precise coding: temp=0.6, top_p=0.95, top_k=20, min_p=0.0
    ;   presence_penalty=0.0, repetition_penalty=1.0
    ; - Thinking mode for general tasks: temp=1.0, top_p=0.95, top_k=20, min_p=0.0
    ;   presence_penalty=1.5, repetition_penalty=1.0
    ; - Native context: 262,144 tokens (recommend at least 128K for thinking capabilities)
    ; - Output: 32K for most queries, 81K for complex problems
    [Jackrong/Qwopus3.5-27B-v3-GGUF]
    hf-repo = Jackrong/Qwopus3.5-27B-v3-GGUF:Q4_K_M
    ctx-size = 262144
    temp = 1.0
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 0.0
    repeat-penalty = 1.0

    ; Gemma-4-31B-it: 31B dense, multimodal (text + image)
    ; Recommended: temp=0.7, top_p=0.95, top_k=40
    ; UD-Q4_K_XL: Unsloth Dynamic quantization
    [unsloth/gemma-4-31B-it-GGUF]
    hf-repo = unsloth/gemma-4-31B-it-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 0.7
    top-p = 0.95
    top-k = 40
    min-p = 0.0

    ; Qwen3.5-35B-A3B: 35B MoE, 3B active per token, 256K context
    ; UD-Q4_K_XL: Unsloth Dynamic, ~21GB
    [unsloth/Qwen3.5-35B-A3B-GGUF]
    hf-repo = unsloth/Qwen3.5-35B-A3B-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 1.0
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    ; Gemma-4-26B-A4B: 26B MoE, 3.8B active, 256K context, multimodal (text + image)
    ; UD-Q4_K_XL: Unsloth Dynamic quantization, ~17GB
    [unsloth/gemma-4-26B-A4B-it-GGUF]
    hf-repo = unsloth/gemma-4-26B-A4B-it-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 1.0
    top-p = 0.95
    top-k = 64
    min-p = 0.0
  '';
in
{
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda";
      cmd = [ "--models-preset" "/presets.ini" "--models-max" "1" "--sleep-idle-seconds" "300" ];
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
