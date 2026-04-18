{ pkgs
, lib
, ...
}:
pkgs.runCommand "inbox"
{
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
  meta.mainProgram = "inbox";
} ''
  mkdir -p $out/bin
  makeWrapper ${pkgs.nushell}/bin/nu $out/bin/inbox \
    --add-flags ${./inbox.nu} \
    --suffix PATH : ${lib.getExe pkgs.gogcli}:${pkgs.nushell}/bin
''
