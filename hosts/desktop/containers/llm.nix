{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    parallel = 1
    jinja = on
    no-warmup = on
    kv-unified = on
    no-host = on
    flash-attn = on
    ngl = all
    spec-draft-ngl = all
    no-mmap = on
    mlock = on
    # threads = 64
    batch-size = 4096
    # batch-size = 2048
    ubatch-size = 512
   
    ctk = q8_0
    ctv = q8_0
  
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 0.0
    repeat-penalty = 1.0

    [localweights/Qwen3.6-27B-MTP-IMAT-IQ4_XS-Q8nextn-GGUF]
    alias = Qwen3.6-27B-MTP
    hf-repo = localweights/Qwen3.6-27B-MTP-IMAT-IQ4_XS-Q8nextn-GGUF
    no-mmproj = true
    spec-type = draft-mtp
    spec-draft-n-max = 4
    spec-draft-p-min = 0.85

    [byteshape/Qwen3.6-35B-A3B-MTP]
    alias = Qwen3.6-35B-A3B-MTP
    hf-repo = byteshape/Qwen3.6-35B-A3B-MTP-GGUF:IQ4_XS-4.19bpw
    spec-type = draft-mtp
    spec-draft-n-max = 4
    spec-draft-p-min = 0.85

    [bartowski/nex-agi_Nex-N2-mini-GGUF]
    alias = Nex-N2-mini
    hf-repo = bartowski/nex-agi_Nex-N2-mini-GGUF:Q4_K_M
    spec-type = ngram-mod
    spec-ngram-mod-n-match = 24
    spec-ngram-mod-n-min = 48
    spec-ngram-mod-n-max = 64
    temp = 0.7
    top-k = 40
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
        "--port"
        "8080"
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
        "/home/knoopx/.cache/huggingface/:/root/.cache/huggingface/"
        "${presets}:/presets.ini:ro"
      ];
      environment = {
        CUDA_SCALE_LAUNCH_QUEUES = "4x";
        GGML_CUDA_GRAPH_OPT = "1";
        GGML_CUDA_FORCE_CUBLAS_COMPUTE_16F = "1";
      };
      extraOptions = [
        "--device=nvidia.com/gpu=all"
      ];
      labels = {
        "traefik.http.services.llm.loadbalancer.server.port" = "8080";
      };
    };
  };
}
