{pkgs, ...}:
pkgs.writeShellScriptBin "niri-cycle" ''
  exec ${pkgs.python3}/bin/python3 ${./niri-cycle.py} "$@"
''
