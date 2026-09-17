{ lib
, nixosConfig
, ...
}: {
  programs.jujutsu.enable = true;
  programs.jujutsu.settings = {
    user = {
      name = nixosConfig.defaults.fullName;
      email = nixosConfig.defaults.primaryEmail;
    };
    ui = {
      editor = lib.getExe nixosConfig.defaults.apps.editor.package;
    };
  };
}
