{
  pkgs,
  nixosConfig,
  ...
} @ inputs: {
  stylix.targets.vscode.profileNames = ["default"];

  programs = {
    vscode = {
      enable = true;
      profiles.default = {
        extensions = import ./_extensions.nix inputs;
        keybindings = import ./_keybindings.nix;
        userSettings = import ./_user-settings.nix inputs;
      };
    };
  };
}
