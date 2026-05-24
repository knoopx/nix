{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    parallel = 1
    jinja = on
    no-warmup = true
    flash-attn = on
    # no-mmap = true
    kv-unified = true

    ctk = q8_0
    ctv = q8_0

    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0

    [localweights/Qwen3.6-27B-MTP-IMAT-IQ4_XS-Q8nextn-GGUF]
    alias = Qwen3.6-27B
    hf-repo = localweights/Qwen3.6-27B-MTP-IMAT-IQ4_XS-Q8nextn-GGUF
    no-mmproj = true
    spec-type = draft-mtp
    spec-draft-n-max = 6
    spec-draft-p-min = 0.75

    [byteshape/Qwen3.6-35B-A3B-MTP]
    alias = Qwen3.6-35B-A3B
    hf-repo = byteshape/Qwen3.6-35B-A3B-MTP-GGUF:IQ4_XS-4.19bpw
    spec-type = draft-mtp
    spec-draft-n-max = 6
    spec-draft-p-min = 0.75

    [Jackrong/Qwopus3.5-9B-Coder-MTP-GGUF]
    alias = Qwopus3.5-9B-Coder
    hf-repo = Jackrong/Qwopus3.5-9B-Coder-MTP-GGUF:Q5_K_M
    spec-type = draft-mtp
    spec-draft-n-max = 6
    spec-draft-p-min = 0.75

    [Jackrong/Qwopus3.6-27B-v2-MTP-GGUF]
    alias = Qwopus3.6-27B-v2
    hf-repo = Jackrong/Qwopus3.6-27B-v2-MTP-GGUF:Q4_K_M
    spec-type = draft-mtp
    spec-draft-n-max = 6
    spec-draft-p-min = 0.75

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
        "--chat-template-file"
        "/chat_template.jinja"
        "--chat-template-kwargs"
        (builtins.toJSON {
          preserve_thinking = true;
        })
        "--spec-default"
      ];
      ports = [
        "11434:8080"
      ];
      volumes = [
        "/home/knoopx/.cache/huggingface/:/root/.cache/huggingface/"
        "${presets}:/presets.ini:ro"
        "${./chat_template.jinja}:/chat_template.jinja:ro"
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
