{pkgs, ...} @ args: {
  ollamark = pkgs.callPackage ./ollamark args;
  importantize = pkgs.callPackage ./importantize.nix args;
}
