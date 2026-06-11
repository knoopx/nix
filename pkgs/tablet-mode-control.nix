{ pkgs }:
pkgs.runCommand "tablet-mode-control" {
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  meta.mainProgram = "tablet-mode-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/tablet-mode-control \
    --add-flags ${./tablet-mode-control.nu}
''
