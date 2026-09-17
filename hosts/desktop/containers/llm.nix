{ config
, lib
, pkgs
, ...
}:
with lib;
let
  modelsDir = "/home/knoopx/.local/share/ninfer/models";

  ninferModels = filter (m: m.ninfer ? artifact && m.ninfer.artifact != null) config.defaults.models.local;

  idleTimeoutSeconds = 5 * 60;

  modelValue = m: filterAttrs (n: v: v != null) {
    artifact = "/models/${m.ninfer.artifact}";
    identity = m.id;
    ttl = idleTimeoutSeconds;
    maxContext = m.contextWindow;
    defaultMaxTokens = m.maxTokens;
    kvCapacity = m.ninfer.kvCapacity;
    kvDtype = m.ninfer.kvDtype;
    prefillChunk = m.ninfer.prefillChunk;
    # The speculative trio is emitted only when a backend is enabled (spec != null).
    spec = if m.ninfer.spec == null then null else m.ninfer.spec;
    draftTokens = if m.ninfer.spec == null then null else m.ninfer.draftTokens;
    lmHeadDraft = if m.ninfer.spec == null then null else m.ninfer.lmHeadDraft;
    # Vision only for models with image/video input (the engine default is off).
    vision = if (any (t: t == "image" || t == "video") m.inputTypes) then true else null;
  };

  ninferServeConfig = pkgs.writeTextDir "ninfer-serve-config.json" (
    builtins.toJSON {
      healthCheckTimeout = 300;
      globalTTL = idleTimeoutSeconds;
      models = listToAttrs (map (m: { name = m.id; value = modelValue m; }) ninferModels);
    }
  );

  image = pkgs.dockerTools.buildImage {
    name = "localhost/llm";
    tag = "latest";
    copyToRoot = [
      pkgs.ninfer
      pkgs.iana-etc
      pkgs.cacert
      ninferServeConfig
    ];
    config = {
      Entrypoint = [ "/bin/ninfer-serve" ];
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
      "--config"
      "/ninfer-serve-config.json"
      "--host"
      "0.0.0.0"
      "--port"
      "11434"

      "--webui"
      "--max-concurrency"
      (toString (foldl' (acc: m: max acc (m.maxConcurrency or 1)) 1 ninferModels))

      "--host-kv-mib"
      "32768"
      "--media-live-mib"
      "2048"
      "--max-pending-requests"
      "2"
      "--pending-timeout-ms"
      "120000"
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
