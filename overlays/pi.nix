# {pkgs, ...}: {
#   pi = pkgs.writeShellScriptBin "pi" ''
#     exec bunx @mariozechner/pi-coding-agent "$@"
#   '';
# }
final: prev: {
  pi = prev.writeShellScriptBin "pi" ''
    exec bunx @mariozechner/pi-coding-agent "$@"
  '';
}
