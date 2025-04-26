{
  lib,
  defaults,
  pkgs,
  ...
}: let
  reloadScript = ''
    if [[ -x "$(command -v gnome-extensions)" ]]; then
      gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com
      gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    fi
  '';
in
  lib.mkIf defaults.wm.gnome {
    xdg.dataFile."themes/Custom/gnome-shell/gnome-shell-dark.css" = {
      source = "${pkgs.custom-gnome-shell-theme}/share/gnome-shell/gnome-shell-dark.css";
      onChange = reloadScript;
    };

    xdg.dataFile."themes/Custom/gnome-shell/gnome-shell-light.css" = {
      source = "${pkgs.custom-gnome-shell-theme}/share/gnome-shell/gnome-shell-light.css";
      onChange = reloadScript;
    };
  }
