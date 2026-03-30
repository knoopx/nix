{pkgs}:
pkgs.runCommand "pick-document" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "pick-document";
} ''
  mkdir -p $out/bin
  cp ${./pick-document.nu} $out/bin/pick-document.nu
  chmod +x $out/bin/pick-document.nu
  makeWrapper $out/bin/pick-document.nu $out/bin/pick-document \
    --suffix PATH : ${pkgs.nushell}/bin
''
