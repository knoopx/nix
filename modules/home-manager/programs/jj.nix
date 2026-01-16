{nixosConfig, ...}: {
  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    user = {
      name = nixosConfig.defaults.fullName;
      email = nixosConfig.defaults.primaryEmail;
    };
    ui = {
      editor = nixosConfig.defaults.editor;
    };
  };
}
