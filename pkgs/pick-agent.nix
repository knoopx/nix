{pkgs}:
pkgs.runCommand "pick-agent" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "pick-agent";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/pick-agent \
    --add-flags ${./pick-agent.nu} \
    --suffix PATH : ${pkgs.nushell}/bin
''