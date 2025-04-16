{pkgs, ...} @ inputs: {
  stylix.targets.vscode.profileNames = ["default"];

  # xdg.configFile."Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json".text = builtins.toJSON {mcpServers = pkgs.callPackage ./_mcp-servers.nix inputs;};

  programs = {
    vscode = {
      enable = true;
      profiles.default = {
        keybindings = import ./_keybindings.nix;
        userSettings = import ./_user-settings.nix inputs;
      };
    };
  };
}
