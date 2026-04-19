{ pkgs, ... }:
let
  presets = pkgs.writeText "presets.ini" ''
    [*]
    flash-attn = on
    no-mmap = true
    jinja = on
    parallel = 1

    ; === Hardware ===
    ; RTX 5090 (32 GB VRAM), AMD Ryzen 9 9950X (16-core), 62 GB system RAM.

    ; === Partial MoE Expert Offloading ===
    ; Model: Qwen3.6-35B-A3B (AesSedai Q5_K_M, 24.44 GiB / 6.06 BPW).
    ; Architecture: 40 layers (0–39), n_embd=2048, expert_ffn_dim=512,
    ;   256 experts total with 8 active per token, GQA 16q/2kv (factor 8).
    ;   MoE quant: up=Q5_K, gate=Q5_K, down=Q6_K.
    ; Tensor names (confirmed via strings on GGUF):
    ;   Conditional experts: blk.X.ffn_gate_exps.weight, blk.X.ffn_up_exps.weight,
    ;                        blk.X.ffn_down_exps.weight
    ;   Shared experts:      blk.X.ffn_gate_shexp.weight, blk.X.ffn_up_shexp.weight,
    ;                        blk.X.ffn_down_shexp.weight (keep on GPU)
    ;   Router:              blk.X.ffn_gate_inp.weight
    ; Pattern matches _exps* suffix (conditional) for layers 35–39 only.
    ; Layers 0–34 stay fully on GPU for fast generation. Only ~12.5% of expert
    ; tensors touch PCIe during inference — enough headroom for desktop without
    ; killing throughput.
    ; Actual observed split (from llama-server logs):
    ;   CUDA0 model buffer: 21,703 MiB (~21.2 GB) — dense + layers 0–34 experts
    ;   CPU host model buffer: 3,325 MiB (~3.2 GB) — layers 35–39 experts
    override-tensor = blk\.(3[5-9])\.ffn_.*_exps.*=CPU

    ; === KV Cache Quantization ===
    ; Observed: ~1,440 MiB at 262k context with q4_0 (10 KV layers × 256 head dim).
    ; Using q8_0 would double to ~2,880 MiB at full context.
    cache-type-k = q4_0
    cache-type-v = q4_0

    ; === Prompt Processing Batch Sizes ===
    ; Compute buffer (observed from logs): 812 MB on CUDA0 + 520 MB on CPU host.
    ; Default llama.cpp values are batch=2048, ubatch=512 — we set both higher
    ; to better utilize the RTX 5090's compute capacity during prompt processing.
    batch-size = 4096
    ub = 2048

    ; Precise coding: temp=0.6, top_p=0.95, top_k=20, min_p=0.0 presence_penalty=0.0, repetition_penalty=1.0
    ; General tasks:  temp=1.0, top_p=0.95, top_k=20, min_p=0.0 presence_penalty=1.5, repetition_penalty=1.0
    [unsloth/Qwen3.6-27B-GGUF]
    hf-repo = unsloth/Qwen3.6-27B-GGUF:UD-Q5_K_XL
    ctx-size = 262144
    temp = 0.8
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
    alias = gpt-3.5-turbo

    ; Precise coding: temp=0.6, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=0.0, repeat-penalty=1.0
    ; General tasks:  temp=1.0, top-p=0.95, top-k=20, min-p=0.0, presence-penalty=1.5, repeat-penalty=1.0
    ; KLD ≈ 0.0065, disk ≈ 24 GB
    [AesSedai/Qwen3.6-35B-A3B-GGUF]
    hf-repo = AesSedai/Qwen3.6-35B-A3B-GGUF:Q5_K_M
    ctx-size = 262144
    temp = 0.8
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0

    [mudler/Qwen3.6-35B-A3B-APEX-GGUF]
    hf-repo = mudler/Qwen3.6-35B-A3B-APEX-GGUF:APEX-I-Balanced
    ctx-size = 262144
    temp = 0.8
    top-p = 0.95
    top-k = 20
    min-p = 0.0
    presence-penalty = 1.5
    repeat-penalty = 1.0
  '';
in
{
  virtualisation.oci-containers.containers = {
    "llm" = {
      autoStart = true;
      image = "ghcr.io/ggml-org/llama.cpp:server-cuda";
      cmd = [
        "--models-preset"
        "/presets.ini"
        "--models-max"
        "1"
        "--sleep-idle-seconds"
        "300"
        "--chat-template-kwargs"
        (builtins.toJSON {
          preserve_thinking = true;
          # enable_thinking = false;
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
      ];
      labels = {
        "traefik.http.services.llm.loadbalancer.server.port" = "8080";
      };
    };
  };
}
