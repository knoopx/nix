{config, ...}: let
  name = "qwen-vllm";
  model = "apolo13x/Qwen3.5-27B-NVFP4";
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
      # "234567"
      "131072"
      # "--max-model-len" "262144"
      "--kv-cache-dtype"
      "fp8_e4m3"
      "--gpu-memory-utilization"
      "0.9"

      "--reasoning-parser"
      "qwen3"
      "--enable-auto-tool-choice"
      "--tool-call-parser"
      "qwen3_coder"

      "--language-model-only"
      # "--enable-prefix-caching"

      "--skip-mm-profiling"
      "--max-num-seqs"
      "1"

      # "--enable-chunked-prefill"

      # "--tensor-parallel-size"
      # "1"
      # "--trust-remote-code"
      # "--max-num-seqs=4"
      # "--max-num-batched-tokens=4096"

      # "--enforce-eager"
      # "--speculative-config"
      # ''{"method":"mtp","num_speculative_tokens":1}''
    ];

    ports = ["11434:8000"];
    volumes = ["${modelCache}:/root/.cache/huggingface"];

    environment = {
      HF_HOME = "/root/.cache/huggingface";
      CUDA_DEVICE_ORDER = "PCI_BUS_ID";
      # VLLM_NVFP4_GEMM_BACKEND = "marlin";
      # VLLM_NVFP4_GEMM_BACKEND = "flashinfer-cutlass"; #
      VLLM_NVFP4_GEMM_BACKEND = "cutlass";
      VLLM_USE_FLASHINFER_MOE_FP4 = "1";
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
