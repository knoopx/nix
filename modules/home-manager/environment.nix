{
  nixosConfig,
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    EDITOR = nixosConfig.defaults.editor;
    DEFAULT_BROWSER = "${lib.getExe pkgs.firefox}";
  };
}
