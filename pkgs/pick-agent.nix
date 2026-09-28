{pkgs}:
pkgs.runCommand "pick-agent" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nushell pkgs.vicinae pkgs.terminal];
  meta.mainProgram = "pick-agent";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/pick-agent \
    --add-flags ${./pick-agent.nu} \
    --suffix PATH : ${pkgs.nushell}/bin
''