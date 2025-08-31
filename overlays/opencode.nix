final: prev: {
  opencode = prev.writeShellScriptBin "oc" ''
    exec bunx opencode-ai@latest "$@"
  '';

  oc-websearch = prev.writeShellScriptBin "oc-websearch" ''
    exec bunx opencode-ai@latest --model github-copilot/gpt-4.1 --agent websearch -p "$@"
  '';

  oc-notes = prev.writeShellScriptBin "oc-notes" ''
    exec bunx opencode-ai@latest --model github-copilot/gpt-4.1 ~/Documents/Notes
  '';
}
