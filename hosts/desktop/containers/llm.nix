{ config
, lib
, pkgs
, ...
}:
with lib;
let
  modelsDir = "/home/knoopx/.local/share/ninfer/models";

  ninferModels = filter (m: m.ninfer ? artifact && m.ninfer.artifact != null) config.defaults.models.local;

  llamaSwapConfig = pkgs.runCommand "llama-swap.yaml"
    {
      nativeBuildInputs = [ pkgs.yq-go ];
    } ''
        mkdir -p $out
        cat <<'JSON' | yq -o yaml . > $out/llama-swap.yaml
        ${builtins.toJSON {
          healthCheckTimeout = 300;
          logToStdout = "upstream";
          logLevel = "debug";
          models = (lib.listToAttrs (map (m:
            {
              name = m.id;
              value = {
                checkEndpoint = "/health";
                ttl = 300;
              cmd = builtins.concatStringsSep " " ([
                  "/bin/ninfer-serve"
                  "/models/${m.ninfer.artifact}"

                  "--model-id ${m.id}"

                  "--host 127.0.0.1"
                  "--port \${PORT}"
                  "--max-pending-requests 2"
                  "--pending-timeout-ms 120000"

                  "--host-kv-mib 32768"
                  "--media-live-mib 2048"
                  # "--max-shared-prefixes 8"
                  # "--response-store-max-mib 4096"
                  # "--response-store-max-records 4096"

                  # "--kv-capacity 240000"
                  "--max-context ${toString m.contextWindow}"
                  "--default-max-tokens ${toString m.maxTokens}"
                  # "--default-thinking-budget ${toString m.maxTokens}"

                ]
                ++ lib.optionals (m.temperature != null) [ "--temperature ${toString m.temperature}" ]
                ++ lib.optionals (m.topP != null) [ "--top-p ${toString m.topP}" ]
                ++ lib.optionals (m.topK != null) [ "--top-k ${toString m.topK}" ]
                ++ lib.optionals (m.minP != null) [ "--min-p ${toString m.minP}" ]
                ++ lib.optionals (m.presencePenalty != null) [ "--presence-penalty ${toString m.presencePenalty}" ]
                ++ lib.optionals m.preserveThinking [ "--preserve-thinking" ]
                ++ lib.optionals (m.maxConcurrency != null) [ "--max-concurrency ${toString m.maxConcurrency}" ]
                ++ [ "--kv-capacity ${m.ninfer.kvCapacity}" ]
                ++ [ "--kv-dtype ${m.ninfer.kvDtype}" ]
                ++ lib.optionals (m.ninfer.spec != null) [ "--spec ${m.ninfer.spec}" ]
                ++ lib.optionals (m.ninfer.spec != null) [ "--draft-tokens ${toString m.ninfer.draftTokens}" ]
                ++ [ "--prefill-chunk ${toString m.ninfer.prefillChunk}" ]
                ++ lib.optionals m.ninfer.lmHeadDraft [ "--lm-head-draft" ]
                ++ lib.optionals (lib.lists.elem "image" m.inputTypes) [ "--vision" ]);
              };
            }
          ) ninferModels));
        }}
    JSON
  '';


  image = pkgs.dockerTools.buildImage {
    name = "localhost/llm";
    tag = "latest";
    copyToRoot = [
      pkgs.llama-swappo
      pkgs.ninfer
      pkgs.iana-etc
      pkgs.cacert
      llamaSwapConfig
    ];
    config = {
      Entrypoint = [ "/bin/llama-swap" ];
      ExposedPorts = {
        "11434/tcp" = { }; # llama-swap (Ollama front-end; serves NInfer models)
      };
    };
  };
in
{
  systemd.tmpfiles.rules = [
    "d ${modelsDir} 0755 knoopx knoopx -"
  ];

  systemd.services.podman-llm.after = [
    "nvidia-container-toolkit-cdi-generator.service"
  ];

  virtualisation.oci-containers.containers.llm = {
    autoStart = true;

    image = "localhost/llm:latest";
    imageFile = image;

    cmd = [
      "--listen"
      ":11434"
      "--config"
      "/llama-swap.yaml"
    ];

    ports = [
      "11434:11434"
    ];

    volumes = [
      "${modelsDir}:/models:ro"
    ];

    extraOptions = [
      "--device=nvidia.com/gpu=all"
    ];

    labels = {
      "traefik.http.services.llm.loadbalancer.server.port" = "11434";
    };
  };
}
