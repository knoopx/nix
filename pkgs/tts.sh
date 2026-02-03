#!/usr/bin/env bash

uv tool install --python 3.13 piper-tts --with pathvalidate > /dev/null 2>&1

model_url="https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/libritts/high/en_US-libritts-high.onnx"
model_path="$HOME/.cache/piper-tts/voices/${model_url##*/}"

mkdir -p "$(dirname "$model_path")"
if [ ! -f "$model_path.json" ]; then
    echo "Downloading model card to $model_path.json ..."
    wget -q -O "$model_path.json" "$model_url.json"
fi

if [ ! -f "$model_path" ]; then
    echo "Downloading model to $model_path ..."
    wget -q -O "$model_path" "$model_url"
fi

if [ -n "$1" ]; then
    echo "$1" | piper --model "$model_path"
else
    piper --model "$model_path"
fi