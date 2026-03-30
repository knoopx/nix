{pkgs}:
pkgs.runCommand "pick-project" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "pick-project";
} ''
  mkdir -p $out/bin
  cp ${./pick-project.nu} $out/bin/pick-project.nu
  chmod +x $out/bin/pick-project.nu
  makeWrapper $out/bin/pick-project.nu $out/bin/pick-project \
    --suffix PATH : ${pkgs.nushell}/bin
''
