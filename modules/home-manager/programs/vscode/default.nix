{pkgs, ...} @ inputs: {
  home.packages = with pkgs; [
    # mcp-server-filesystem
    # mcp-server-fetch
    # mcp-server-playwright
    # mcp-server-puppeteer
    # mcp-server-sqlite
    # mcp-server-google-maps
    # mcp-server-git
    # mcp-server-time
  ];

  stylix.targets.vscode.profileNames = ["default"];

  xdg.configFile."Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json".text = builtins.toJSON {mcpServers = import ./_mcp-servers.nix inputs;};

  programs = {
    vscode = {
      enable = true;
      profiles.default = {
        keybindings = import ./_keybindings.nix inputs;
        userSettings = import ./_user-settings.nix inputs;
      };
    };
  };
}
