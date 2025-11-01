{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = nixosConfig.defaults.editor;
    DEFAULT_BROWSER = "${lib.getExe pkgs.firefox}";
  };
}
