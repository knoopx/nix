{ pkgs
, lib
, ...
}:
pkgs.runCommand "events"
{
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  meta.mainProgram = "events";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/events \
    --add-flags ${./events.nu} \
    --suffix PATH : ${lib.getExe pkgs.gogcli}:${pkgs.nushell}/bin
''
