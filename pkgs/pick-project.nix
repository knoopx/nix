{pkgs}:
pkgs.runCommand "pick-project" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "pick-project";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/pick-project \
    --add-flags ${./pick-project.nu} \
    --suffix PATH : ${pkgs.nushell}/bin
''
