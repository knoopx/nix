final: prev: {
  opencode = prev.writeShellScriptBin "oc" ''
    exec bunx opencode-ai@latest "$@"
  '';
}
