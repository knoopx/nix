{ lib
, pkgs
, ...
}:
with lib;
let
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

  # hf download neroued/Qwen3.8-27B-NInfer \
  #   qwen3_8_27b.ninfer \
  #   --local-dir ${modelsDir}

  modelsDir = "/home/knoopx/.local/share/ninfer/models";
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

    image = "localhost/ninfer:latest";
    imageFile = image;

    cmd = [
      # "/models/qwen3_8_27b.ninfer"
      "/models/qwen3_8_27b_nvfp4.ninfer"

      "--host"
      "0.0.0.0"

      "--port"
      "8080"

      "--model-id"
      "qwen3.8-27b"

      # "--vision"

      "--max-concurrency"
      "2"

      "--max-context"
      "131072"

      "--kv-capacity"
      "auto"

      "--kv-dtype"
      "int8"

      "--spec"
      "mtp"

      "--draft-tokens"
      "4"

      "--lm-head-draft"

      "--default-max-tokens"
      "16384"

      "--prefill-chunk"
      "4096"
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
