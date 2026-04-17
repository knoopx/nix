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

    ; Thinking mode for precise coding: temp=0.6, top_p=0.95, top_k=20, min_p=0.0 presence_penalty=0.0, repetition_penalty=1.0
    ; Thinking mode for general tasks: temp=1.0, top_p=0.95, top_k=20, min_p=0.0 presence_penalty=1.5, repetition_penalty=1.0
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

    ; Precise coding: temp=0.6, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=0.0, repeat-penalty=1.0
    ; General tasks: temp=1.0, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=1.5, repeat-penalty=1.0
    ; preserve_thinking: enabled for agent scenarios (maintains full reasoning context)
    [unsloth/Qwen3.6-35B-A3B-GGUF]
    hf-repo = unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q5_K_XL
    ctx-size = 131072
    temp = 0.8
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    
    [mudler/Qwen3.5-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Qwen3.5-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    [mudler/Qwopus-MoE-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Qwopus-MoE-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    [mudler/LFM2-24B-A2B-APEX-GGUF]
    hf-repo = mudler/LFM2-24B-A2B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    [mudler/GLM-4.7-Flash-APEX-GGUF]
    hf-repo = mudler/GLM-4.7-Flash-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    [mudler/Holo3-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Holo3-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    
    [mudler/Carnice-MoE-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Carnice-MoE-35B-A3B-APEX-GGUF:APEX-I-Balanced
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

