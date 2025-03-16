# docker run --device nvidia.com/gpu=all \
# -v ~/.cache/huggingface:/root/.cache/huggingface \
# --ipc=host -p 8000:8000 \
# vllm/vllm-openai \
# --model Qwen/Qwen2.5-Coder-32B-Instruct-AWQ \
# --tensor-parallel-size 2 \
# --quantization awq_marlin --enable-auto-tool-choice --tool-call-parser hermes \
# --kv-cache-dtype fp8_e5m2 \
# --rope-scaling '{ "factor": 4.0, "original_max_position_embeddings": 32768, "rope_type": "yarn" }'
_: let
  vllm-openai = name: args: {
    autoStart = true;
    serviceName = name;
    image = "vllm/vllm-openai:latest";
    volumes = [
      "/home/knoopx/.cache/vllm:/root/.cache/huggingface"
    ];
    labels = {
      "traefik.enable" = "false";
    };
    extraOptions = [
      "--ipc=host"
      "--device=nvidia.com/gpu=all"
    ];
    cmd = args;
    ports = ["8000:8000"];
    environment = {
      HF_HUB_ENABLE_HF_TRANSFER = "false";
      VLLM_ATTENTION_BACKEND = "FLASHINFER";
    };
  };
in {
  virtualisation.oci-containers.containers = {
    "vllm-qwen-coder" = vllm-openai "qwen-coder" [
      "--model"
      "Qwen/Qwen2.5-Coder-14B-Instruct-AWQ"
      # "--tensor-parallel-size"
      # "2"
      "--quantization"
      "awq_marlin"
      "--enable-auto-tool-choice"
      "--tool-call-parser"
      "hermes"
      "--kv-cache-dtype"
      "fp8_e5m2"
      "--rope-scaling"
      ''{ "factor": 4.0, "original_max_position_embeddings": 32768, "rope_type": "yarn" }''
    ];
  };
}
