final: prev: {
  opencode = prev.writeShellScriptBin "oc" ''
    exec bunx opencode-ai@latest "$@"
  '';

  websearch = prev.writeShellScriptBin "websearch" ''
    exec kitty bunx opencode-ai@latest --model github-copilot/gpt-4.1 --agent websearch -p "$@"
  '';
}
