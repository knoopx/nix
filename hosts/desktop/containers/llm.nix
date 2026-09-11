{ config
, lib
, pkgs
, ...
}:
with lib;
let
  modelsDir = "/home/knoopx/.local/share/ninfer/models";

  ninferModels = filter (m: m.ninfer ? artifact && m.ninfer.artifact != null) config.defaults.models.local;

  # 5-minute idle timeout (TTL): the router unloads a loaded model once it has been idle longer
  # than the per-model `ttl` (if set) or `globalTTL` (below).
  idleTimeoutSeconds = 5 * 60;

  # Per-model serve-config entry. The engine knobs come from the model's `ninfer` block
  # (modules/nixos/defaults/models.nix) plus its context/output budgets; the serving layer
  # applies them to that model's Engine at load. `null` fields are dropped so the engine
  # falls back to its registered defaults.
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

  # Native ninfer-serve multi-model router config (JSON; consumed by --config).
  # Must be writeTextDir (a directory), not writeText: dockerTools' layer builder
  # rsyncs each copyToRoot item as `item/` into the layer, which chdirs INTO it.
  ninferServeConfig = pkgs.writeTextDir "ninfer-serve-config.json" (
    builtins.toJSON {
      healthCheckTimeout = 300;
      globalTTL = idleTimeoutSeconds; # 5-minute idle timeout (unloads the last-loaded model)
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
        "11434/tcp" = { }; # ninfer-serve (native multi-model router; OpenAI + Anthropic APIs)
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

    # Native multi-model router: one process, in-process Engine swaps, FIFO scheduling.
    # Per-model engine options (max-context, default-max-tokens, kv-capacity, kv-dtype, spec,
    # draft-tokens, prefill-chunk, lm-head-draft, vision) live in the serve-config JSON, derived
    # from each model's ninfer block. The CLI keeps only the global memory/ingress options.
    cmd = [
      "--config"
      "/ninfer-serve-config.json"
      "--host"
      "0.0.0.0"
      "--port"
      "11434"

      "--webui"

      # The single concurrency setting: --max-concurrency (the engine's decode-batch count and
      # the router's admission gate for every model), the max of each model's `maxConcurrency`
      # option (models.nix, default 3).
      "--max-concurrency"
      (toString (foldl' (acc: m: max acc (m.maxConcurrency or 1)) 1 ninferModels))

      # --- Global memory / ingress (shared across all models) ---
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
