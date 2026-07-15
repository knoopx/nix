{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    parallel = 1
    # jinja = on
    # no-warmup = on
    # kv-unified = on;
    # no-host = on
    # flash-attn = on
    # ngl = all
    # spec-draft-ngl = all
    # no-mmap = on
    # mlock = on
    ctx-size = 131072
    # threads = 64
    # batch-size = 4096
    # batch-size = 2048
    # ubatch-size = 512
    ctk = q8_0
    ctv = q8_0

    # temp = 0.6
    # top-p = 0.95
    # top-k = 20
    # min-p = 0.0

    temp = 1.0
    top-p = 0.95
    top-k = 0
    min-p = 0

    presence-penalty = 0.0
    repeat-penalty = 1.0

    spec-draft-n-max = 4
    spec-draft-p-min = 0.85

    # spec-draft-n-max = 3
    # spec-draft-p-min = 0.6

    no-mmproj = true

    [bytkim/Qwen3.6-27B-MTP-pi-reasoning-GGUF:Q5_K_M]
    hf-repo = bytkim/Qwen3.6-27B-MTP-pi-reasoning-GGUF:Q5_K_M
    no-mmproj = true
    spec-type = draft-mtp

    [mudler/Qwen3.6-35B-A3B-APEX-MTP-GGUF:QUALITY]
    hf-repo = mudler/Qwen3.6-35B-A3B-APEX-MTP-GGUF:APEX-MTP-I-Quality
    ctx-size = 262144    
    no-mmproj = false
    spec-type = draft-mtp

    [prism-ml/Bonsai-27B-gguf:Q1_0]
    hf-repo = prism-ml/Bonsai-27B-gguf:q1_0
    no-mmproj = true
    ctx-size = 262144
  '';
in
{
  systemd.services.podman-llm.after = [
    "nvidia-container-toolkit-cdi-generator.service"
  ];

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
      environment = { };
      extraOptions = [
        "--device=nvidia.com/gpu=all"
      ];
      labels = {
        "traefik.http.services.llm.loadbalancer.server.port" = "8080";
      };
    };
  };
}
