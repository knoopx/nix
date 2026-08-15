{ lib
, pkgs
, ...
}:
with lib;
let
  # Container image built purely from the ninfer derivation — no registry
  # base image. `dockerTools.buildImage` with `fromImage = null` is the
  # "FROM scratch" case: the image's single layer is the nix store closure of
  # copyToRoot, copied into the image at the same /nix/store/<hash>/... paths.
  #
  # The closure carries the CUDA 13.2 runtime stack (cudart, nvtx), ffmpeg,
  # curl and glibc; iana-etc/cacert are the base-less-image extras recommended
  # by the dockerTools docs (getprotobyname + TLS for curl).
  #
  # The GPU driver is NOT in the image: the host supplies libcuda.so.1 via the
  # nvidia-container-toolkit CDI spec, injected with --device=nvidia.com/gpu=all.
  image = pkgs.dockerTools.buildImage {
    name = "localhost/ninfer";
    tag = "latest";
    copyToRoot = [
      pkgs.ninfer
      pkgs.iana-etc
      pkgs.cacert
    ];
    config = {
      Entrypoint = [ "${pkgs.ninfer}/bin/ninfer-serve" ];
    };
  };

  # The ~17 GiB model artifact is deliberately not baked into the image; it is
  # a read-only volume. Download it once (see ninfer README):
  #
  #   hf download neroued/Qwen3.8-27B-NInfer \
  #     qwen3_8_27b.ninfer \
  #     --local-dir ${modelsDir}
  #
  # sha256: eec39564993d6e9c7d5e383382a760f093465c9d163ec9a1bd6b80199514bf3e
  modelsDir = "/home/knoopx/.local/share/ninfer/models";
in
{
  # Ensure the host-side models volume directory exists (idempotent,
  # stateVersion-friendly).
  systemd.tmpfiles.rules = [
    "d ${modelsDir} 0755 knoopx knoopx -"
  ];

  systemd.services.podman-llm.after = [
    "nvidia-container-toolkit-cdi-generator.service"
  ];

  virtualisation.oci-containers.containers.llm = {
    autoStart = true;

    # Matches the name:tag inside the imageFile below; `podman load` in the
    # service preStart makes it available locally, so no registry pull happens.
    image = "localhost/ninfer:latest";
    imageFile = image;

    # ninfer-serve takes the .ninfer artifact as its first positional arg,
    # then server flags. No --vision: the deployment serves text only.
    cmd = [
      "/models/qwen3_8_27b.ninfer"
      "--host" "0.0.0.0"
      "--port" "8080"
      "--model-id" "qwen3.8-27b"
      "--max-context" "131072"
      "--kv-capacity" "auto"
      "--max-concurrency" "2"
      "--spec" "mtp"
      "--draft-tokens" "3"
      "--lm-head-draft"
    ];

    ports = [
      "11434:8080"
    ];

    volumes = [
      "${modelsDir}:/models:ro"
    ];

    extraOptions = [
      "--device=nvidia.com/gpu=all"
    ];

    labels = {
      "traefik.http.services.llm.loadbalancer.server.port" = "8080";
    };
  };
}
