{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = nixosConfig.defaults.editor;
    DEFAULT_BROWSER = "${lib.getExe pkgs.firefox-esr}";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
