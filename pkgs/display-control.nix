{pkgs}:
pkgs.runCommand "display-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "display-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/display-control \
    --add-flags ${./display-control.nu} \
    --suffix PATH : ${pkgs.niri}/bin:${pkgs.nushell}/bin
''
