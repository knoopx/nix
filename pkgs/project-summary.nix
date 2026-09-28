{pkgs, ...}:
pkgs.runCommand "project-summary"
{
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  runtimeInputs = [pkgs.nushell pkgs.git];
  meta.mainProgram = "project-summary";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/project-summary \
    --add-flags ${./project-summary.nu} \
    --suffix PATH : ${pkgs.git}/bin:${pkgs.nushell}/bin
''
