{nixosConfig, ...}: {
  home.sessionVariables = {
    EDITOR = nixosConfig.defaults.editor;
  };
}
