{config, ...}: let
  name = "qwen-vllm";
  model = "apolo13x/Qwen3.5-27B-NVFP4";
  # model = "mconcat/Qwen3.5-27B-Claude-4.6-Opus-Reasoning-Distilled-NVFP4";
  modelCache = "/home/${config.defaults.username}/.cache/huggingface";
in {
  virtualisation.oci-containers.containers."${name}" = {
    serviceName = name;
    autoStart = false;
    image = "docker.io/vllm/vllm-openai:cu130-nightly";

    cmd = [
      model
      "--served-model-name"
      "Qwen3.5-27B-NVFP4"

      "--max-model-len"
      "131072"
      # "234567"
      # "--max-model-len" "262144"
      "--max-num-seqs"
      "1" # 4
      # "--max-num-batched-tokens" "4096"
      "--tensor-parallel-size"
      "1"
      # "--enable-chunked-prefill"
      # "--enable-prefix-caching"
      # "--load-format"
      # "fastsafetensors"

      "--attention-backend"
      "flashinfer"
      "--language-model-only"
      "--skip-mm-profiling"

      "--kv-cache-dtype"
      "fp8_e4m3"
      "--gpu-memory-utilization"
      "0.92"

      "--reasoning-parser"
      "qwen3"
      "--enable-auto-tool-choice"
      "--tool-call-parser"
      "qwen3_coder"

      # "--trust-remote-code"

      # "--enforce-eager"
      "--speculative-config"
      ''{"method":"mtp","num_speculative_tokens":2}''
    ];

    ports = ["11434:8000"];
    volumes = ["${modelCache}:/root/.cache/huggingface"];

    environment = {
      HF_HOME = "/root/.cache/huggingface";
      CUDA_DEVICE_ORDER = "PCI_BUS_ID";
      # VLLM_NVFP4_GEMM_BACKEND = "marlin";
      # VLLM_NVFP4_GEMM_BACKEND = "flashinfer-cutlass";
      VLLM_NVFP4_GEMM_BACKEND = "cutlass";
      VLLM_USE_FLASHINFER_MOE_FP4 = "1";

      # VLLM_WORKER_MULTIPROC_METHOD = "spawn";
      # SAFETENSORS_FAST_GPU = "1";
      # VLLM_DISABLE_PYNCCL = "1";
      # NCCL_IB_DISABLE = "1";
    };

    extraOptions = ["--device=nvidia.com/gpu=all" "--ipc=host"];
  };

  systemd.tmpfiles.settings."${name}-cache" = {
    "${modelCache}".d = {
      user = config.defaults.username;
      group = "users";
      mode = "0755";
    };
  };
}
