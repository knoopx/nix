{
  pkgs,
  lib,
}:
let
  pkg = (pkgs.callPackage ./gram.nix {});
in
  pkgs.runCommand "editor" {
    nativeBuildInputs = [pkgs.makeBinaryWrapper];
    meta.mainProgram = "editor";
  } ''
    mkdir -p $out/bin
    makeWrapper ${lib.getExe pkg} $out/bin/editor
  ''
