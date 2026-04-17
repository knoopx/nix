{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = lib.getExe nixosConfig.defaults.apps.editor.package;
    DEFAULT_BROWSER = lib.getExe nixosConfig.defaults.apps.browser.package;
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
