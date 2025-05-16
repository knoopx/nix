{
  pkgs,
  lib,
  ...
}:
# pkgs.writeShellApplication {
#   name = "md2pango";
#   runtimeInputs = with pkgs; [nodejs nodePackages.remark];
#   text = ''
#     export NODE_PATH="${pkgs.nodePackages.postcss}/lib/node_modules"
#     node ${./scripts/md2pango.js} "$@"
#   '';
# }
pkgs.stdenvNoCC.mkDerivation {
  name = "md2pango";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-YN8ltjYAG39K/GLEebssRMf0XzBeofVoMcQdwJ2yXxw=";
  dontUnpack = true;

  src = ./scripts/md2pango.js;

  buildPhase = ''
    ${lib.getExe pkgs.bun} add remark
    install -D -m755 $src $out/bin/md2pango
    mkdir -p $out/bin/node_modules
    cp -r node_modules/* $out/bin/node_modules
  '';
}
