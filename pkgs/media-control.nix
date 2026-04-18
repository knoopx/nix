{pkgs}:
pkgs.runCommand "media-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "media-control";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/media-control \
    --add-flags ${./media-control.nu} \
    --suffix PATH : ${pkgs.playerctl}/bin:${pkgs.nushell}/bin
''
