{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = nixosConfig.defaults.editor;
    DEFAULT_BROWSER = "${lib.getExe pkgs.browser}";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
