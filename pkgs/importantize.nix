{pkgs, ...}:
pkgs.writeShellApplication {
  name = "importantize";
  runtimeInputs = with pkgs; [nodejs nodePackages.postcss];
  text = ''
    export NODE_PATH="${pkgs.nodePackages.postcss}/lib/node_modules"
    node ${./importantize.js} "$@"
  '';
}
