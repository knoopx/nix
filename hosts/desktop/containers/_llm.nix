{pkgs, ...}: let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    n-gpu-layers = -1
    flash-attn = on
    models-max = 1
    threads = 2
    batch-size = 1024
    ubatch-size = 512
    mlock = on
    jinja = on
    cont-batching = on
    cache-type-k = q8_0
    cache-type-v = q8_0

    [qwen3.5-35b-a3b]
    model = /models/unsloth_Qwen3.5-35B-A3B-GGUF_Qwen3.5-35B-A3B-UD-Q4_K_M.gguf
    mmproj = /models/unsloth_Qwen3.5-35B-A3B-GGUF_mmproj-BF16.gguf
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0

    [qwen3-coder-next]
    model = /models/unsloth_Qwen3-Coder-Next-GGUF_Qwen3-Coder-Next-UD-IQ3_XXS.gguf
    ctx-size = 262144
    temp = 1.0
    top-p = 0.95
    top-k = 40
    min-p = 0.01
  '';
in {
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda";
      cmd = ["--models-preset" "/presets.ini" "--sleep-idle-seconds" "300"];
      volumes = [
        "/home/knoopx/.cache/llama.cpp:/models"
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
