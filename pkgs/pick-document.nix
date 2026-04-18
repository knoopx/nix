{pkgs}:
pkgs.runCommand "pick-document" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "pick-document";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/pick-document \
    --add-flags ${./pick-document.nu} \
    --suffix PATH : ${pkgs.nushell}/bin
''
