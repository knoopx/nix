{
  pkgs,
  nixosConfig,
  ...
} @ inputs: {
  stylix.targets.vscode.profileNames = ["default"];

  xdg.configFile."Code/User/mcp.json" = {
    text = builtins.toJSON {servers = nixosConfig.defaults.ai.mcp;};
  };

  xdg.configFile."Code/User/prompts/" = {
    source = ./prompts;
    recursive = true;
  };

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
