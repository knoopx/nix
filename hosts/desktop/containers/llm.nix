{ config
, lib
, pkgs
, ...
}:
with lib;
let
  modelsDir = "/home/knoopx/.local/share/ninfer/models";

  ninferModels = filter (m: m.ninferArtifact != null) config.defaults.models.local;

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
          models = lib.listToAttrs (map (m:
            {
              name = m.id;
              value = {
                checkEndpoint = "/health";
                ttl = 300;
              cmd = builtins.concatStringsSep " " ([
                  "/bin/ninfer-serve"
                  "/models/${m.ninferArtifact}"
                  "--model-id ${m.id}"
                  "--host 127.0.0.1"
                  "--port \${PORT}"
                  "--max-context ${toString m.contextWindow}"
                  "--default-max-tokens ${toString m.maxTokens}"
                ]
                ++ [ "--max-concurrency ${toString m.ninferMaxConcurrency}" ]
                ++ [ "--kv-capacity ${m.ninferKvCapacity}" ]
                ++ [ "--kv-dtype ${m.ninferKvDtype}" ]
                ++ lib.optionals (m.ninferSpec != null) [ "--spec ${m.ninferSpec}" ]
                ++ lib.optionals (m.ninferSpec != null) [ "--draft-tokens ${toString m.ninferDraftTokens}" ]
                ++ lib.optionals (m.ninferSpec != null) [ "--draft-tokens-min ${toString m.ninferDraftTokensMin}" ]
                ++ [ "--prefill-chunk ${toString m.ninferPrefillChunk}" ]
                ++ lib.optionals m.ninferLmHeadDraft [ "--lm-head-draft" ]
                ++ lib.optionals m.ninferVision [ "--vision" ]);
              };
            }
          ) ninferModels);
        }}
    JSON
  '';

  image = pkgs.dockerTools.buildImage {
    name = "localhost/llm";
    tag = "latest";
    copyToRoot = [
      pkgs.llama-swap-minimal
      pkgs.ninfer
      pkgs.iana-etc
      pkgs.cacert
      llamaSwapConfig
    ];
    config = {
      Entrypoint = [ "/bin/llama-swap" ];
      ExposedPorts = {
        "11434/tcp" = { };
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
