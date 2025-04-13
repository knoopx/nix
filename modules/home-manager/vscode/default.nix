{
  pkgs,
  config,
  defaults,
  lib,
  home,
  ...
}: {
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

  xdg.configFile."Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json".text = builtins.toJSON {mcpServers = import ./mcp-servers.nix {inherit pkgs config home;};};

  programs = {
    vscode = {
      enable = true;
      package =
        pkgs.vscode.override
        {
          commandLineArgs = [
            "--disable-features=WaylandFractionalScaleV1"
          ];
        };

      profiles.default = {
        keybindings = import ./keybindings.nix {};
        userSettings = import ./user-settings.nix {inherit pkgs defaults lib config home;};
      };
    };
  };
}
