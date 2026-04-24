{
  pkgs,
  ik-llama,
  ...
}: let
  # Build with explicit Blackwell sm_120 support for RTX 5090
  cudaPkgs = import ik-llama.inputs.nixpkgs {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
      cudaSupport = true;
      cudaCapabilities = ["12.0"];
    };
  };

  # Apply the overlay to get llamaPackages scope with CUDA build
  llamaPkgs = (ik-llama.overlays.default) cudaPkgs cudaPkgs;
  ikLlama = llamaPkgs.llamaPackages."llama-cpp".overrideAttrs (old: {
    cmakeFlags =
      [
        "-DGGML_CUDA=ON"
        "-DCMAKE_CUDA_ARCHITECTURES=120"
      ]
      ++ (old.cmakeFlags or []);
  });

  # CUDA runtime library path for container
  cudaLibPath = cudaPkgs.lib.makeLibraryPath [
    cudaPkgs.cudaPackages.cuda_cudart
    cudaPkgs.cudaPackages.libcublas
  ];

  # Build docker image for nix-oci-containers
  dockerImage = pkgs.dockerTools.buildLayeredImage {
    name = "ik-llama";
    tag = "latest";

    contents = [
      ikLlama
      pkgs.bash
      pkgs.coreutils
      cudaPkgs.cudaPackages.cuda_cudart
      cudaPkgs.cudaPackages.libcublas
    ];

    fakeRootCommands = ''
      mkdir -p tmp
      chmod 1777 tmp
    '';

    config = {
      Entrypoint = ["${ikLlama}/bin/llama-server"];
      Env = [
        "LD_LIBRARY_PATH=${cudaLibPath}:/usr/lib64:/usr/lib/x86_64-linux-gnu"
        "NVIDIA_DRIVER_CAPABILITIES=compute,utility"
        "NVIDIA_VISIBLE_DEVICES=all"
      ];
      ExposedPorts = {
        "8080/tcp" = {};
      };
      WorkingDir = "/models";
      Volumes = {
        "/models" = {};
      };
    };
  };

  presets = pkgs.writeText "presets.ini" ''
    [*]
    flash-attn = on
    no-mmap = true
    no-warmup = true
    jinja = on
    parallel = 1

    threads = 64
    prio = 2
    cache-type-k = q4_0
    cache-type-v = q4_0

    batch-size = 4096
    ubatch-size = 2048

    [unsloth/Qwen3.6-27B-GGUF]
    hf-repo = unsloth/Qwen3.6-27B-GGUF:UD-Q4_K_XL
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0

    [AesSedai/Qwen3.6-35B-A3B-GGUF]
    alias = Qwen3.6-35B-A3B
    hf-repo = AesSedai/Qwen3.6-35B-A3B-GGUF:Q5_K_M
    ctx-size = 262144
    temp = 0.6
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    override-tensor = blk\.(3[5-9])\.ffn_.*_exps.*=CPU
  '';
in {
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ik-llama:latest";
      imageFile = dockerImage;
      cmd = [
        # "--models-preset"
        # "/presets.ini"
        # "--models-max"
        # "1"
        # "--sleep-idle-seconds"
        # "300"
        "-m"
        "/root/.cache/huggingface/hub/models--unsloth--Qwen3.6-27B-GGUF/snapshots/82d411acf4a06cfb8d9b073a5211bf410bfc29bf/Qwen3.6-27B-UD-Q4_K_XL.gguf"

        "--parallel"
        "1"
        "--temp"
        "0.6"
        "--top-p"
        "0.95"
        "--top-k"
        "20"
        "--min-p"
        "0.0"
        "--repeat-penalty"
        "1.0"
        "--presence-penalty"
        "1.5"

        "-ngl"
        "99"
        "-fa"
        "on"
        "--fit"
        # "--fit-margin"
        # "128"
        "-ctk"
        "q8_0"
        "-ctv"
        "q8_0"
        "--run-time-repack"
        "--host"
        "0.0.0.0"
        "--port"
        "8080"
        "--jinja"
        "-c"
        "131072"
        "--chat-template-kwargs"
        (builtins.toJSON {
          preserve_thinking = true;
        })
      ];
      ports = [
        "11434:8080"
      ];
      volumes = [
        "/home/knoopx/.cache/llama.cpp/:/root/.cache/llama.cpp/"
        "/home/knoopx/.cache/huggingface/:/root/.cache/huggingface/"
        "${presets}:/presets.ini:ro"
      ];
      extraOptions = [
        "--device=nvidia.com/gpu=all"
        "--security-opt=label=disable"
      ];
      labels = {
        "traefik.http.services.llm.loadbalancer.server.port" = "8080";
      };
    };
  };
}
