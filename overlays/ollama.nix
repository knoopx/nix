final: prev: {
  opencode = prev.writeShellScriptBin "ollama" ''
    sudo podman exec ollama ollama "$@"
  '';
}
