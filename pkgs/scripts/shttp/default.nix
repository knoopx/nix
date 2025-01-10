{
  pkgs,
  lib,
  ...
}:
pkgs.writeShellApplication {
  name = "shttp";
  text = ''
    ${lib.getExe pkgs.bun} "${./shttp.js}" "$@"
  '';
}
