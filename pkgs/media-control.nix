{ pkgs }:

pkgs.runCommand "media-control" {
  nativeBuildInputs = [pkgs.makeBinaryWrapper];
  meta.mainProgram = "media-control";
} ''
  mkdir -p $out/bin
  cp ${./media-control.nu} $out/bin/media-control.nu
  chmod +x $out/bin/media-control.nu
  makeWrapper $out/bin/media-control.nu $out/bin/media-control \
    --suffix PATH : ${pkgs.playerctl}/bin:${pkgs.nushell}/bin
''