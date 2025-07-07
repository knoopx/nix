{
  pkgs,
  nixosConfig,
  ...
} @ inputs: {
  stylix.targets.vscode.profileNames = ["default"];

  # xdg.configFile."Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json".text = builtins.toJSON {servers = pkgs.callPackage ./_mcp-servers.nix inputs;};
  xdg.configFile."Code/User/mcp.json".text = builtins.toJSON {servers = nixosConfig.ai.mcp;};
  xdg.configFile."Code - Insiders/User/mcp.json".text = builtins.toJSON {servers = nixosConfig.ai.mcp;};

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
