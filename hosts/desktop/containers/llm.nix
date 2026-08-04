{ config
, lib
, pkgs
, ...
}:
with lib;
let
  modelSections = map
    (model: ''
      [${model.id}]
      hf-repo = ${model.hfRepo}
      ctx-size = ${toString model.contextWindow}
      ctk = ${model.ctk}
      ctv = ${model.ctv}
      temp = ${toJSON model.temp}
      top-p = ${toJSON model.topP}
      top-k = ${toString model.topK}
      min-p = ${toJSON model.minP}
      presence-penalty = ${toJSON model.presencePenalty}
      repeat-penalty = ${toJSON model.repeatPenalty}
      spec-draft-n-max = ${toString model.specDraftNMax}
      spec-draft-p-min = ${toJSON model.specDraftPMin}
      spec-type = ${model.specType}
      no-mmproj = ${toString (!elem "image" model.inputTypes)}
      parallel = ${toString model.parallel}
      no-warmup = ${if model.warmup then "off" else "on"}
      kv-unified = ${if model.kvUnified then "on" else "off"}
      flash-attn = ${if model.flashAttn then "on" else "off"}
      ngl = ${model.numGpuLayers}
      spec-draft-ngl = ${model.specDraftNgl}
      no-mmap = ${if model.mmap then "off" else "on"}
      mlock = ${if model.mlock then "on" else "off"}
      batch-size = ${toString model.batchSize}
      ubatch-size = ${toString model.ubatchSize}
    '')
    config.defaults.models.local;

  presets = pkgs.writeText "presets.ini" ''
    ${concatStringsSep "\n" modelSections}
  '';

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
in
{
  systemd.services.podman-llm.after = [
    "nvidia-container-toolkit-cdi-generator.service"
  ];

  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda13";
      inherit cmd;
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
