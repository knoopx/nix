# docker run --runtime nvidia --gpus all \
# -v ~/.cache/huggingface:/root/.cache/huggingface \
# --ipc=host -p 8000:8000 \
# vllm/vllm-openai \
# --model Qwen/Qwen2.5-32B-Instruct-AWQ
# --tensor-parallel-size 2 \
# --quantization awq_marlin --enable-auto-tool-choice --tool-call-parser hermes \
# --kv-cache-dtype fp8_e5m2 \
# --rope-scaling '{ "factor": 4.0, "original_max_position_embeddings": 32768, "type": "yarn" }'
_: let
  vllm-openai = name: args: {
    autoStart = true;
    serviceName = name;
    image = "vllm/vllm-openai";
    volumes = [
      "~/.cache/huggingface:/root/.cache/huggingface"
    ];
    labels = {
      "traefik.enable" = "false";
    };
    extraOptions = [
      "--device"
      "nvidia.com/gpu=all"
    ];
    cmd = args;
  };
in {
  virtualisation.oci-containers.containers = {
    "vllm-openai" = vllm-openai "qwen" [
      "--model Qwen/Qwen2.5-32B-Instruct-AWQ"
      # "--tensor-parallel-size 2"
      # "--quantization awq_marlin"
      # "--enable-auto-tool-choice"
      # "--tool-call-parser hermes"
      # "--kv-cache-dtype fp8_e5m2"
    ];
  };
}
