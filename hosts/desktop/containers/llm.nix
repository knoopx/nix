{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    parallel = 1
    flash-attn = on
    no-mmap = true
    jinja = on
    no-warmup = true
    no-mmproj = true
    reasoning = on

    ctk = q8_0
    ctv = q8_0

    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 0.0
    repeat-penalty = 1.0

    [Qwen/Qwen3.6-27B-MTP]
    alias = Qwen3.6-27B
    hf-repo = unsloth/Qwen3.6-27B-MTP-GGUF:UD-Q4_K_XL
    # ctx-size = 131072

    spec-type = draft-mtp
    spec-draft-n-max = 4
    cache-type-k-draft = q4_0
    cache-type-v-draft = q4_0 
    
    temp = 1.0
    presence-penalty = 1.5

    [unsloth/Qwen3.6-35B-A3B-MTP]
    alias = Qwen3.6-35B-A3B
    hf-repo = unsloth/Qwen3.6-35B-A3B-MTP-GGUF:UD-Q4_K_XL
    temp = 1.0
    presence-penalty = 1.5
    # ctx-size = 131072
    # spec-type = draft-mtp
    # spec-draft-n-max = 6    
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
