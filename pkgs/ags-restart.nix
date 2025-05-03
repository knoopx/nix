{pkgs, ...}:
pkgs.writeShellScriptBin "ags-restart" ''
  pkill gjs
  ags run &
  disown
  notify-send "AGS" "AGS restarted!"
''
